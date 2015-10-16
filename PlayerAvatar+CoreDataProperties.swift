//
//  PlayerAvatar+CoreDataProperties.swift
//  DotaWatcher
//
//  Created by lunner on 10/8/15.
//  Copyright © 2015 lunner. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PlayerAvatar {

    @NSManaged var image: NSData?
    @NSManaged var player: Player?

}
