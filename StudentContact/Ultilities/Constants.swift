//
//  Constants.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/29/20.
//

import Foundation

enum Constant {
    static let maxNameLength: Int = 25
    static let maxPhoneNumberLength: Int = 12
    static let maxEmailLength: Int = 50
    
    static let editStudentTitle = "Edit Student"
    static let addStudentTitle = "Add Student"
}

enum ViewControllerIdentifier {
    static let studentDetailViewController = "StudentDetailViewController"
    static let addEditStudentViewController = "AddEditStudentViewController"
}
