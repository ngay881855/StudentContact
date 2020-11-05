//
//  Student.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/18/20.
//

import Foundation
import UIKit

struct Student {
    var identity: Int
    var profileImage: UIImage
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var isFavorite: Bool
    
    init() {
        identity = -1
        profileImage = UIImage(imageLiteralResourceName: "defaultProfile")
        firstName = ""
        lastName = ""
        phoneNumber = ""
        email = ""
        isFavorite = false
    }
    
    init(profileImage: UIImage, firstName: String, lastName: String, phoneNumber: String, email: String, isFavorite: Bool, identity: Int = -1) {
        self.identity = identity
        self.profileImage = profileImage
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.isFavorite = isFavorite
    }
}
