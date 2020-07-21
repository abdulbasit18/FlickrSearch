//
//  PhotoResponse.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct PhotoResponseModel: Decodable {
    let photos: PhotoModel
}

struct PhotoModel: Decodable {
    let page: Int?
    let total: String?
    let pages: Int?
    let photo: [PhotoDTO]?
}
