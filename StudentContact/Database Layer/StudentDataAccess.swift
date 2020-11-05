//
//  StudentDataAccess.swift
//  StudentContact
//
//  Created by Ngay Vong on 10/30/20.
//

import Foundation
import SQLite3

class StudentDataAccess {
    var dbManager: DBManager
    
    required init(dbManager: DBManager = DBManager()) {
        self.dbManager = dbManager
        self.dbManager.startDatabase()
        try? self.createTableIfRequired()
    }
    
    deinit {
        self.dbManager.closeDbConnection()
    }
    
    private func createTableIfRequired() throws {
            let createTableQuery = """
                CREATE TABLE IF NOT EXISTS "Student" (
                    "First Name"    TEXT NOT NULL DEFAULT "",
                    "Last Name"    TEXT NOT NULL DEFAULT "",
                    "Gender"    TEXT NOT NULL DEFAULT "",
                    "Email"    TEXT NOT NULL DEFAULT "",
                    "Mobile"    TEXT NOT NULL,
                    "Profile Pic"    BLOB,
                    "id"    INTEGER NOT NULL UNIQUE,
                    PRIMARY KEY("id" AUTOINCREMENT)
                );
            """
        
        let dbHandlerStatement = try dbManager.prepareStatement(query: createTableQuery)

        try dbManager.executeStatement(dbHandler: dbHandlerStatement)
        print("Table created")
    }
    
    func insert(student: Student) throws {
        let query = """
                Insert Into Student ("First name", "Last Name", "Email", "Mobile")
                Values ('\(student.firstName)', '\(student.lastName)', '\(student.email)', '\(student.phoneNumber)')
                """
        let dbHandlerStatement = try dbManager.prepareStatement(query: query)
        try dbManager.executeStatement(dbHandler: dbHandlerStatement)
        
        print("Student added successfully")
    }
    
    func getAllStudents() -> [Student] {
        var students: [Student] = []
        let query = "Select * From Student"
        do {
            let dbHandlerStatement = try dbManager.prepareStatement(query: query)
            
            while sqlite3_step(dbHandlerStatement) == SQLITE_ROW {
                var student = Student()
                student.identity = Int(sqlite3_column_int(dbHandlerStatement, 5))
                if let queryResultCol0 = sqlite3_column_text(dbHandlerStatement, 0) {
                    student.firstName = String(cString: queryResultCol0)
                } else {
                    print("Query result is nil.")
                }
                
                if let queryResultCol1 = sqlite3_column_text(dbHandlerStatement, 1) {
                    student.lastName = String(cString: queryResultCol1)
                } else {
                    print("Query result is nil.")
                }
                
                if let queryResultCol3 = sqlite3_column_text(dbHandlerStatement, 3) {
                    student.email = String(cString: queryResultCol3)
                } else {
                    print("Query result is nil.")
                }
                
                if let queryResultCol4 = sqlite3_column_text(dbHandlerStatement, 4) {
                    student.phoneNumber = String(cString: queryResultCol4)
                } else {
                    print("Query result is nil.")
                }
                
                students.append(student)
            }
            sqlite3_finalize(dbHandlerStatement)
        } catch {
            print(error)
        }
        return students
    }
}
