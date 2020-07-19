//
//  PhotoRequest.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct PhotoRequestModel: Encodable {
    
    let method = "flickr.photos.search"
    let api_key: String
    let tags: String
    let page: Int
    let format = "json"
    let per_page = "10"
    let nojsoncallback = "1"
}
