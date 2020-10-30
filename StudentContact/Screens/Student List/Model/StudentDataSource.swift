//
//  StudentDataSource.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/25/20.
//

import Foundation
struct StudentDataSource {
    var section: [String] {
        didSet {
            section.sort(by: <)
        }
    }
    var dataSource: [String: [Student]] {
        didSet {
            for (key, _) in dataSource {
                dataSource[key]?.sort { str1, str2 -> Bool in
                    str1.firstName < str2.firstName
                }
            }
        }
    }
}
