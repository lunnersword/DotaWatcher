//
//  Ability.swift
//  DotaWatcher
//
//  Created by lunner on 9/9/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import CoreData

class Ability: NSManagedObject {

    @NSManaged var cooldown: NSNumber?
    @NSManaged var desc: String
    @NSManaged var hero_id: NSNumber
    @NSManaged var img_url: String
    @NSManaged var left_details: String
    @NSManaged var lore: String?
    @NSManaged var mana_cost: String?
    @NSManaged var name: String
    @NSManaged var vid_url: String
    @NSManaged var abilityDetails: NSOrderedSet?
    @NSManaged var hero: Hero
	@NSManaged var image_hp1: AbilityImage1
	@NSManaged var image_hp2: AbilityImage2
}
