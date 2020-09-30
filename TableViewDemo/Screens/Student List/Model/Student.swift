//
//  Student.swift
//  TableViewDemo
//
//  Created by Ngay Vong on 9/18/20.
//
import UIKit
import Foundation

struct Student {
    var profileImage: UIImage
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var isFavorite: Bool
    
    init() {
        profileImage = #imageLiteral(resourceName: "defaultProfile")
        firstName = ""
        lastName = ""
        phoneNumber = ""
        email = ""
        isFavorite = false
    }
    
    init(profileImage: UIImage, firstName: String, lastName: String, phoneNumber: String, email: String, isFavorite: Bool) {
        self.profileImage = profileImage
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.isFavorite = isFavorite
    }
}
