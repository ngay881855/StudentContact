//
//  DBManager.swift
//  StudentContact
//
//  Created by Ngay Vong on 10/30/20.
//

import Foundation
import SQLite3

enum SqliteError: Error {
    case invalidDirectoryUrl
    case invalidBundleUrl
    case copyFailed
    case openDbFailed
    case prepareFailed
    case tableCreationError
    case insertFailed
    case deleteFailed
}

protocol DatabaseProvider {

    var dbPath: String { get }
    var dbName: String { get }
    var dbPointer: OpaquePointer? { get }
}

class DBManager: DatabaseProvider {

    var dbName: String
    var dbPath: String = ""
    
    var dbPointer: OpaquePointer?
    
    required init(dbName: String = "StudentContact.db") {
        self.dbName = dbName
    }
    
    deinit {
        sqlite3_close(self.dbPointer)
    }

    private func createDbIfNeeded() throws {
        
        func copyDbIfRequired(atDestination destinationPath: String) throws {
            
            guard let bundlePath = Bundle.main.resourceURL?.appendingPathComponent(self.dbName) else {
                throw SqliteError.invalidBundleUrl
            }
            if FileManager.default.fileExists(atPath: destinationPath) {
                print("Document already exists")
            } else if FileManager.default.fileExists(atPath: bundlePath.path) {
                print("Database file doesn't exist, copy from bundle")
                do {
                    try FileManager.default.copyItem(atPath: bundlePath.path, toPath: destinationPath)
                } catch {
                    throw SqliteError.copyFailed
                }
            }
        }
        
        // Get documents directory
        do {
            guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                // Throw an error if not found
                throw SqliteError.invalidDirectoryUrl
            }
            
            self.dbPath = docDirectory.appendingPathComponent(self.dbName).path
            // Copy db to document directory if required
            try copyDbIfRequired(atDestination: self.dbPath)
        } catch let error as SqliteError {
            throw error
        }
    }
    
    private func openDbConnection() throws -> OpaquePointer? {
        var opaquePointer: OpaquePointer? // Swift type for C pointers, this is required to access the db or interact with the db
        if sqlite3_open(self.dbPath, &opaquePointer) == SQLITE_OK {
            // db opened
            return opaquePointer
        } else {
            // db openning failed
            throw SqliteError.openDbFailed
        }
    }
    
    func closeDbConnection() {
        sqlite3_close(self.dbPointer)
    }
    
    func startDatabase() {
        try? self.createDbIfNeeded()
        self.dbPointer = try? self.openDbConnection()
    }
    
    func prepareStatement(query: String) throws -> OpaquePointer? {
        var localPointer: OpaquePointer?
        if sqlite3_prepare_v2(self.dbPointer, query, -1, &localPointer, nil) == SQLITE_OK {
            print("prepare success")
            return localPointer
        } else {
            print("prepare failed")
            throw SqliteError.prepareFailed
        }
    }
    
    func finalizeStatement(dbHandler: OpaquePointer?) {
        sqlite3_finalize(dbHandler)
    }
    
    func executeStatement(dbHandler: OpaquePointer?) throws {
        defer {
            sqlite3_finalize(dbHandler)
        }
        guard  sqlite3_step(dbHandler) == SQLITE_DONE else {
            throw SqliteError.tableCreationError
        }
        print("Statement executed successfully")
    }
}
