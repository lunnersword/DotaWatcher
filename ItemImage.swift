//
//  ItemImage.swift
//  DotaWatcher
//
//  Created by lunner on 9/10/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import CoreData

class ItemImage: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var item: Item

}
