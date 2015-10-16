//
//  DotaWatcherTests.swift
//  DotaWatcherTests
//
//  Created by lunner on 9/8/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import UIKit
import XCTest
import CoreData

class DotaWatcherTests: XCTestCase {
    
	var coreDataStack: TestCoreDataStack!
	var appDelegate: AppDelegate!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		coreDataStack = TestCoreDataStack()
		appDelegate = AppDelegate()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		coreDataStack = nil
		appDelegate = nil
        super.tearDown()
    }
	func testImportHerosIfNeed() {
		
	}
	
	func testImportHerosJSONData() {
		self.expectationForNotification(NSManagedObjectContextDidSaveNotification, object: coreDataStack.rootContext, handler: {
			notification in
			return true
		})
		appDelegate.importHerosJSONData(coreDataStack, contextMode: 0)
		
		self.waitForExpectationsWithTimeout(20.0, handler: {
			error in
			XCTAssertNil(error, "Save did not occur")
		})
		
		// fetch here count
		let fetchRequest = NSFetchRequest(entityName: "Hero")
		fetchRequest.resultType = .CountResultType
		let fetchHeroRequest = NSFetchRequest(entityName: "Hero")
		fetchHeroRequest.predicate = NSPredicate(format: "hero_id == 72")
		fetchHeroRequest.resultType = .ManagedObjectResultType
		coreDataStack.rootContext.performBlock({
			[unowned self] () -> Void in

			let result = try? self.coreDataStack.rootContext.executeFetchRequest(fetchRequest) as? [NSNumber]
			var count: Int? = nil
			if let countArray = result {
			 count = countArray![0].integerValue
			}
			print("\(count)")
			XCTAssertTrue(count == 110, "there should have 110 heros")
			// fetch hero with id 72
			
			let heros = try? self.coreDataStack.rootContext.executeFetchRequest(fetchHeroRequest)
			var hero: Hero?
			if let temp = heros {
				hero = temp.first as? Hero
			}
			XCTAssertNotNil(hero, "hero should not nil")
			XCTAssertTrue(hero?.atk_range == 365, "dmg should be 17 - 27")
			XCTAssertTrue(hero?.abilities.count == 4 , "should have 4 abilities")
			XCTAssertTrue((hero?.levelAttributes.objectAtIndex(0) as! LevelAttribute).armor == 17, "armor should 16")
		})
		

		
		
		
	}
    
	func testImportItemsJSONData() {
		self.expectationForNotification(NSManagedObjectContextDidSaveNotification, object: coreDataStack.rootContext, handler: {
			notification in
			
			return true
		})
		appDelegate.importItemsJSONData(coreDataStack, contextMode: 0)
		
		self.waitForExpectationsWithTimeout(20.0, handler: {
			error in
			XCTAssertNil(error, "Save did not occur")
		})
		
		// fetch item count
		let fetchRequest = NSFetchRequest(entityName: "Item")
		fetchRequest.resultType = .CountResultType
		coreDataStack.rootContext.performBlock({
			[unowned self] () -> Void in

			let result = try? self.coreDataStack.rootContext.executeFetchRequest(fetchRequest) as? [NSNumber]
			var count: Int? = nil
			if let countArray = result {
				count = countArray![0].integerValue
			}
			XCTAssertTrue(count == 170, "there should have 110 items")
		})
		
		

	}
	
    func testExample() {
        // This is an example of a functional test case.

        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
