//
//  TestCoreDataStack.swift
//  DotaWatcher
//
//  Created by lunner on 9/9/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import Foundation
import CoreData

class TestCoreDataStack: CoreDataStack {
	override init() {
		super.init()
		self.persistentStoreCoordinator = {
			let psc: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

			
			let ps = try? psc!.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
			
			if ps == nil {
				abort()
			}
			
			return psc
		}()
	}
}
