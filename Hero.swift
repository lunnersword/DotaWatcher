//
//  Hero.swift
//  DotaWatcher
//
//  Created by lunner on 9/9/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import CoreData

class Hero: NSManagedObject {

    @NSManaged var hero_id: NSNumber
    @NSManaged var name: String
    @NSManaged var img_url: String
    @NSManaged var lore: String
    @NSManaged var agi: String
    @NSManaged var armor: NSNumber
    @NSManaged var atk_range: NSNumber
    @NSManaged var atk_type: String
    @NSManaged var dmg: String
    @NSManaged var int: String
    @NSManaged var localized_name: String
    @NSManaged var missile_spd: NSNumber
    @NSManaged var move_spd: NSNumber
    @NSManaged var portrait_img_url: String
    @NSManaged var primary_attribute: String
    @NSManaged var roles: String
    @NSManaged var sight_range: String
    @NSManaged var str: String
    @NSManaged var abilities: NSOrderedSet
    @NSManaged var levelAttributes: NSOrderedSet
    @NSManaged var fullImage: HeroFullImage
    @NSManaged var largeImage: HeroLargeImage
    @NSManaged var smallImage: HeroSmallImage
    @NSManaged var portraitImage: HeroPortraitImage

}
