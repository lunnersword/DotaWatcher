//
//  AbilityDetail.swift
//  DotaWatcher
//
//  Created by lunner on 9/9/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import CoreData

class AbilityDetail: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var detail: String
    @NSManaged var ability: Ability

}
