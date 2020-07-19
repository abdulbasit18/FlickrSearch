//
//  PhotoRequest.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct PhotoRequest: Encodable {
    let page: Int
    let api_key: String
}
