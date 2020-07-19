//
//  Photo+CoreDataProperties.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id: Int64
    @NSManaged public var owner: String?
    @NSManaged public var secret: String?
    @NSManaged public var server: String?
    @NSManaged public var farm: String?
    @NSManaged public var title: String?
    @NSManaged public var isPublic: Bool
    @NSManaged public var isfriend: Bool
    @NSManaged public var isfamily: Bool
    
}
