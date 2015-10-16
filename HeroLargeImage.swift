//
//  HeroLargeImage.swift
//  DotaWatcher
//
//  Created by lunner on 9/9/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import CoreData

class HeroLargeImage: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var hero: Hero

}
