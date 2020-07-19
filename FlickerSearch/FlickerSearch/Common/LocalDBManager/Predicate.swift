//
//  Predicate.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct Predicate {
    var format: String
    var arguments: [Any]
    init(format: String, arguments: [Any]) {
        self.format = format
        self.arguments = arguments
    }
}
