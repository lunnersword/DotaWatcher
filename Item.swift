//
//  Item.swift
//  DotaWatcher
//
//  Created by lunner on 9/10/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var localized_name: String
    @NSManaged var name: String
    @NSManaged var img: String
    @NSManaged var notes: String?
    @NSManaged var cd: NSNumber
    @NSManaged var qual: String
    @NSManaged var mc: NSNumber
    @NSManaged var cost: NSNumber
    @NSManaged var lore: String
    @NSManaged var attrib: String?
    @NSManaged var id: NSNumber
    @NSManaged var desc: String?
    @NSManaged var components: String?
    @NSManaged var image: ItemImage

}
