//
//  CoreDataStack.swift
//  DotaWatcher
//
//  Created by lunner on 9/9/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStack {
	//var semaphore: dispatch_semaphore_t
	init() {
		//semaphore = dispatch_semaphore_create(1)
	}
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	var applictionDocumentsDirectory: NSURL = {
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.count-1] 
	}()
	var managedObjectModel: NSManagedObjectModel = {
		let modelPath = NSBundle.mainBundle().pathForResource("DotaWatcher", ofType: "momd")
		let modelURL = NSURL.fileURLWithPath(modelPath!)
		let model = NSManagedObjectModel(contentsOfURL: modelURL)!
		return model
	}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		NSLog("Providing SQLite persistent store coordinator")
		let url = self.applictionDocumentsDirectory.URLByAppendingPathComponent("DotaWatcher.sqlite")
		var options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
		var error: NSError? = nil
		var psc: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		var ps = try? psc!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
		if (ps == nil) {
			// 
			abort()
		}
		return psc
	}()
	
	lazy var rootContext: NSManagedObjectContext = {
		var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
		context.persistentStoreCoordinator = self.persistentStoreCoordinator
		context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		return context
	}()
	lazy var mainContext: NSManagedObjectContext = {
		var mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
		mainContext.parentContext = self.rootContext
		mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		NSNotificationCenter.defaultCenter().addObserver(self , selector: "mainContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: mainContext)
		return mainContext
	}()
	
	func newDerivedContext() -> NSManagedObjectContext {
		let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
		context.parentContext = mainContext
		context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		return context
	}
	
	func saveContext(context: NSManagedObjectContext) {
		//dispatch_semaphore_wait(semaphore, 10*NSEC_PER_SEC)
		context.performBlock() {
			do {
				try context.obtainPermanentIDsForObjects(Array(context.insertedObjects))
				try context.obtainPermanentIDsForObjects(Array(context.deletedObjects))
				try context.obtainPermanentIDsForObjects(Array(context.updatedObjects))
				try context.save()
			} catch {
				print("\(error)")
			}
/*
			if !(context.obtainPermanentIDsForObjects(Array(context.insertedObjects), error: &error)) {
				NSLog("Error obtaining permanent IDs for \(context.insertedObjects), \(error)")
			}
			error = nil
			if !(context.obtainPermanentIDsForObjects(Array(context.deletedObjects), error: &error)) {
				NSLog("Error obtaining permanent IDs for \(context.deletedObjects), \(error)")
			}
			error = nil
			if !(context.obtainPermanentIDsForObjects(Array(context.updatedObjects), error: &error)) {
				NSLog("Error obtaining permanent IDs for \(context.updatedObjects), \(error)")
			}
			error = nil
			if !(context.save(&error)) {
				NSLog("Unresolved core data error: \(error)")
				abort()
			}
*/
			if context.parentContext === self.mainContext {
				self.saveContext(self.mainContext)
			}
		}

	}
	
	@objc func mainContextDidSave(notifcation: NSNotification) {
		self.saveContext(self.rootContext)
	}
	
	
	
}
