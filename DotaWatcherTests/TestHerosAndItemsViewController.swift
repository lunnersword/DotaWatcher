//
//  TestHerosAndItemsViewController.swift
//  DotaWatcher
//
//  Created by lunner on 9/21/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit
import XCTest
import CoreData


class TestHerosAndItemsViewController: XCTestCase {
	var viewController: HerosAndItemsViewController?
	var coreDataStack: TestCoreDataStack?
	var appDelegate: AppDelegate!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		coreDataStack = TestCoreDataStack()
		viewController = HerosAndItemsViewController()
		viewController?.coreDataStack = coreDataStack
		appDelegate = AppDelegate()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		coreDataStack = nil
		viewController = nil
        super.tearDown()
    }
    
	func testLoadHeros() {
		appDelegate.importHerosJSONData(viewController!.coreDataStack!, contextMode: 1)
		//asyc importHeros so here wait it finished

		self.viewController?.loadHeros()
		XCTAssertTrue(self.viewController?.strengthHeros.count == 36)
		XCTAssertTrue(self.viewController?.agilityHeros.count == 34)
		XCTAssertTrue(self.viewController?.intelligenceHeros.count == 40)
//		for hero in (self.viewController!.strengthHeros as! [Hero]) {
//			print("\(hero)")
//		}


	}
	
	func testLoadItems() {
		appDelegate.importItemsJSONData(viewController!.coreDataStack!)
		viewController!.loadItems()
		
		XCTAssertNotNil(viewController!.consumableItems as NSArray)
		XCTAssertTrue(viewController?.consumableItems.count == 12)
		XCTAssertTrue(viewController?.attributeItems.count == 11)
		XCTAssertTrue(viewController?.armamentItems.count == 12)
		print("\(viewController!.armamentItems.count)")
		XCTAssertTrue(viewController?.arcaneItems.count == 13)
		XCTAssertTrue(viewController?.commonItems.count == 13)
		XCTAssertTrue(viewController?.supportItems.count == 13)
		XCTAssertTrue(viewController?.casterItems.count == 13)
		XCTAssertTrue(viewController?.weaponItems.count == 13)
		XCTAssertTrue(viewController?.armorItems.count == 13)
		print("\(viewController!.armorItems.count)")
		XCTAssertTrue(viewController?.artifactItems.count == 12)
		XCTAssertTrue(viewController?.secretItems.count == 12)
	}
	
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
