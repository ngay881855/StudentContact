//
//  File.swift
//  Q20
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
                dataSource[key]?.sort(by: { (s1, s2) -> Bool in
                    s1.firstName < s2.firstName
                })
            }
        }
    }
}
