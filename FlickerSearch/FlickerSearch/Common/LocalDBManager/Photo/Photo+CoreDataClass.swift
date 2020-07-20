//
//  Photo+CoreDataClass.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 19/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {

    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(context: NSManagedObjectContext) {
        let entityDesc = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        super.init(entity: entityDesc!, insertInto: context)
    }

    init(tag: String, photoDTO: PhotoDTO, context: NSManagedObjectContext) {

        let entityDesc = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        super.init(entity: entityDesc!, insertInto: context)

        self.id = photoDTO.id
        self.owner = photoDTO.owner
        self.secret = photoDTO.secret
        self.server = photoDTO.server
        self.title = photoDTO.title
        self.tag = tag
    }
}
