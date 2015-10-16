//
//  LevelAttribute.swift
//  DotaWatcher
//
//  Created by lunner on 9/9/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import CoreData

class LevelAttribute: NSManagedObject {

    @NSManaged var armor: NSNumber
    @NSManaged var damage: String
    @NSManaged var hit_points: NSNumber
    @NSManaged var level: NSNumber
    @NSManaged var mana: NSNumber
    @NSManaged var hero: Hero

}
