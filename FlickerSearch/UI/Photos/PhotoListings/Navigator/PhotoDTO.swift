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
    let owner: String
    let secret: String
    let server: String
    let farm: String
    let title: String
    let isPublic: Bool
    let isfriend: Bool
    let isfamily: Bool
}
//id : "50128172178"
//owner : "159189159@N02"
//secret : "e4cfd3cc1d"
//server : "65535"
//farm : 66
//title : "Smartie being thick"
//ispublic : 1
//isfriend : 0
//isfamily : 0
