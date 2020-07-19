//
//  PhotoResponse.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct PhotoResponse: Decodable {
    let photos: PhotoModel
}

struct PhotoModel: Decodable {
    let page: Int?
    let total: Int?
    let pages: Int?
    let photo: [PhotoDTO]?
}
