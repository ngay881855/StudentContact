//
//  StudentInfo.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/25/20.
//

import Foundation

struct StudentInfo {
    var key: String
    var value: String
    var keyType: StudentInfoKey
}

enum StudentInfoKey: String {
    case firstName = "First Name"
    case lastName = "Last Name"
    case phone = "Phone"
    case email = "Email"
}
