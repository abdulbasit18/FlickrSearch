//
//  Constants.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Keys {
        static let api = "f9cc014fa76b098f9e82f1c288379ea1"
    }
    
    struct API {
        static let baseURL  = "https://api.flickr.com/services/rest/"
        static let imageBaseURL = "https://farm%d.staticflickr.com/%@/%@_%@_\(Constants.size.url_s.value).jpg"
    }
    
//    https://live.staticflickr.com/5800/31456463045_5a0af4ddc8_q.jpg
    
    enum size: String {
        case sqaure = "s"   //small square 75x75
        case largeSqaure = "q"    //large square 150x150
        case thumbnail = "t"    //thumbnail, 100 on longest side
        case small240 = "m"    //small, 240 on longest side
        case small320 = "n"    //small, 320 on longest side
        case medium500 = "-"    //medium, 500 on longest side
        case medium640 = "z"    //medium 640, 640 on longest side
        case medium800 = "c"    //medium 800, 800 on longest side†
        case large1024 = "b"    //large, 1024 on longest side*
        case large1600 = "h"    //large 1600, 1600 on longest side†
        case large2048 = "k"    //large 2048, 2048 on longest side†
        case orignal = "o"    //original image, either a jpg, gif or png, depending on source format
        
        var value: String {
            return self.rawValue
        }
    }
}
