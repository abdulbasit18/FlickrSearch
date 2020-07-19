//
//  PhotoDTO.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct PhotoDTO: Decodable {
    let id: Int
    let owner: String?
    let secret: String?
    let server: String?
    let farm: String?
    let title: String?
    let isPublic: Bool?
    let isfriend: Bool?
    let isfamily: Bool?
}
