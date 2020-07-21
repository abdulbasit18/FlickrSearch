//
//  PhotoDTO.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxDataSources

struct PhotoDTO: Decodable {
    let farm: Int?
    let id: String
    let owner: String?
    let secret: String?
    let server: String?
    let title: String?
}

struct PhotoSection {
    var header: String
    var items: [Item]
    var uniqueId: String = "1"
}

extension PhotoSection: AnimatableSectionModelType {
    
    typealias Item = PhotoDTO
    typealias Identity = String
    
    init(original: PhotoSection, items: [Item]) {
        self = original
        self.items = items
    }
    var identity: String {
        return uniqueId
    }
}

extension PhotoDTO: IdentifiableType, Equatable {
    
    typealias Identity = UUID
    
    var identity: UUID {
        return UUID()
    }
}
