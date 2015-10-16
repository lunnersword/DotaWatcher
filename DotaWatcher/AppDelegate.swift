//
//  AppDelegate.swift
//  DotaWatcher
//
//  Created by lunner on 9/8/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import UIKit
import CoreData
let HeroCount = 110
let ItemCount = 170
enum Preferece: String {
	case IsLogin = "IsLoginName"
	case IsFirstLaunch = "ISFirstLaunchName"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	lazy var coreDataStack = CoreDataStack()
	lazy var dotaApi = DotaApi()

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		let userDefaults = NSUserDefaults.standardUserDefaults()
		let defaults = [Preferece.IsFirstLaunch.rawValue: true]
		userDefaults.registerDefaults(defaults)
		let isFirstLaunch = userDefaults.boolForKey(Preferece.IsFirstLaunch.rawValue)
		let herosAndItemsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HerosAndItemsViewController") as! HerosAndItemsViewController
		if isFirstLaunch {
			NSNotificationCenter.defaultCenter().addObserver(herosAndItemsViewController, selector: "rootContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: coreDataStack.rootContext)
		}
		
		importHerosIfNeeded(coreDataStack)
		importItemsIfNeeded(coreDataStack)
		//coreDataStack.saveContext(coreDataStack.rootContext)
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func importHerosIfNeeded(coreDataStack: CoreDataStack) {
		var importRequired = false
		let fetchRequest = NSFetchRequest(entityName: "Hero")
		var error: NSError? = nil
		let heroCount = coreDataStack.mainContext.countForFetchRequest(fetchRequest, error: &error)
		if heroCount != HeroCount {
			importRequired = true
		}
		
		if importRequired {
			// remove already stored heros in the context

			if let results = try? coreDataStack.mainContext.executeFetchRequest(fetchRequest) {
				for object in results {
					let hero = object as! Hero
					coreDataStack.mainContext.deleteObject(hero)
				}
			}
			coreDataStack.saveContext(coreDataStack.mainContext)
			importHerosJSONData(coreDataStack, contextMode: 0)
		}
		
	}
	
	func importItemsIfNeeded(coreDataStack: CoreDataStack) {
		var importRequired = false
		let fetchRequest = NSFetchRequest(entityName: "Item")
		var error: NSError?
		let itemCount = coreDataStack.mainContext.countForFetchRequest(fetchRequest, error: &error)
		if itemCount != ItemCount {
			importRequired = true
		}
		if importRequired {
			//remove already stored items in the context

			if let results = try? coreDataStack.mainContext.executeFetchRequest(fetchRequest) {
				for object in results {
					let item = object as! Item
					coreDataStack.mainContext.deleteObject(item)
				}
			}
			coreDataStack.saveContext(coreDataStack.mainContext)
			importItemsJSONData(coreDataStack, contextMode: 0)
		}
	}
		
	func importItemsJSONData(coreDataStack: CoreDataStack, contextMode: Int = 1) {
		//contextMode 0 for rootContext, 1 for mainContext, 2 for newDerivedContext
		var context: NSManagedObjectContext
		switch contextMode {
		case 0:
			context = coreDataStack.rootContext
		case 1:
			context = coreDataStack.mainContext
		case 2:
			context = coreDataStack.newDerivedContext()
		default:
			context = coreDataStack.mainContext
		}
		let jsonURL = NSBundle.mainBundle().URLForResource("items_en_US", withExtension: "json")
		let jsonData = NSData(contentsOfURL: jsonURL!)

		let jsonArray = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers) as! NSArray
		
		let itemEntity = NSEntityDescription.entityForName("Item", inManagedObjectContext: context)
		let itemImageEntity = NSEntityDescription.entityForName("ItemImage", inManagedObjectContext: context)
		var counter = 0
		for itemDict in jsonArray {
			let itemDict = itemDict as! NSDictionary
			counter++
			var attrib: String? = nil 
			if let attribTemp = itemDict["attrib"] as? String {
				if attribTemp != "" {
					attrib = attribTemp
				}
			} 
			
			let cd = NSNumber(integer: Int(itemDict["cd"] as! String)!) 
			var components: String? = nil
			if let temp = itemDict["components"] as? String {
				if temp != "" {
					components = temp
				}
			}
			
			let cost = NSNumber(integer: Int(itemDict["cost"] as! String)!)
			var desc: String? = nil 
			if let temp = itemDict["desc"] as? String {
				if temp != "" {
					desc = temp
				}
			}
			
			let id = NSNumber(integer: Int(itemDict["id"] as! String)!)
			
			let img = itemDict["img"] as! String
			let localized_name = itemDict["localized_name"] as! String
			let lore = itemDict["lore"] as! String
			let mc = NSNumber(integer: Int(itemDict["mc"] as! String)!)
			let name = itemDict["name"] as! String
			var notes: String? = nil
			if let temp = itemDict["notes"] as? String {
				if temp != "" {
					notes = temp
				}
			}
			
			let qual = itemDict["qual"] as! String
			
			let item = Item(entity: itemEntity!, insertIntoManagedObjectContext: context)
			item.attrib = attrib
			item.cd = cd
			item.components = components
			item.cost = cost
			item.desc = desc
			item.id = id
			item.img = img
			item.localized_name = localized_name
			item.lore = lore
			item.mc = mc
			item.name = name
			item.notes = notes
			item.qual = qual
			
			// item image
			let parts = item.img.componentsSeparatedByString(".")
			let imageURL = NSBundle.mainBundle().URLForResource(parts[0], withExtension: parts[1])
			let imageData = NSData(contentsOfURL: imageURL!)
			
			let itemImage = ItemImage(entity: itemImageEntity!, insertIntoManagedObjectContext: context)
			itemImage.image = imageData!
			itemImage.item = item 
			
		}
		coreDataStack.saveContext(context)
		//move to didFinishLaunch, after import heros and items save context a single time
		print("Imported \(counter) items")
		
	}
	
	func importHerosJSONData(coreDataStack: CoreDataStack, contextMode: Int = 1) {
		//contextMode 0 for rootContext, 1 for mainContext, 2 for newDerivedContext
		var context: NSManagedObjectContext
		switch contextMode {
		case 0:
			context = coreDataStack.rootContext
		case 1:
			context = coreDataStack.mainContext
		case 2:
			context = coreDataStack.newDerivedContext()
		default:
			context = coreDataStack.mainContext
		}

		let jsonURL = NSBundle.mainBundle().URLForResource("heroes_english", withExtension: "json")
		let jsonData = NSData(contentsOfURL: jsonURL!)
		let jsonArray = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers) as! NSArray
		let heroEntity = NSEntityDescription.entityForName("Hero", inManagedObjectContext: context)
		let abilityEntity = NSEntityDescription.entityForName("Ability", inManagedObjectContext: context)
		let abilityDetailEntity = NSEntityDescription.entityForName("AbilityDetail", inManagedObjectContext: context)
		let levelAttributeEntity = NSEntityDescription.entityForName("LevelAttribute", inManagedObjectContext: context)
		let heroFullImageEntity = NSEntityDescription.entityForName("HeroFullImage", inManagedObjectContext: context)
		let heroLargeImageEntity = NSEntityDescription.entityForName("HeroLargeImage", inManagedObjectContext: context)
		let heroSmallImageEntity = NSEntityDescription.entityForName("HeroSmallImage", inManagedObjectContext: context)
		let heroPortraitImageEntity = NSEntityDescription.entityForName("HeroPortraitImage", inManagedObjectContext: context)
		let abilityImage1Entity = NSEntityDescription.entityForName("AbilityImage1", inManagedObjectContext: context)
		let abilityImage2Entity = NSEntityDescription.entityForName("AbilityImage2", inManagedObjectContext: context)
		var counter = 0
		for jsonArrayElement   in jsonArray  {
			counter++
			let jsonDictionary = jsonArrayElement as! NSDictionary
			// get hero properties
			
			let heroID = NSNumber(integer: Int(jsonDictionary["hero_id"] as! String)!)
			let agi = jsonDictionary["agi"] as! String
			//let armorStr = (jsonDictionary["armor"] as? String)
			let armor = NSNumber(float: (jsonDictionary["armor"] as! NSString).floatValue)
			let atkType = jsonDictionary["atk_type"] as! String
			let atkRange = NSNumber(integer: Int(jsonDictionary["atk_range"] as! String)!)
			//let desc = jsonDictionary["description"] as? String
			let dmg = jsonDictionary["dmg"] as! String
			let imgURL = jsonDictionary["img_url"] as! String
			let int = jsonDictionary["int"] as! String
			let localizedName = jsonDictionary["localized_name"] as! String
			let lore = jsonDictionary["lore"] as! String
			// missile_spd 9 heros is "N/A", replace it with 0
			var missleSPD: NSNumber 
			let missleSPDStr = jsonDictionary["missile_spd"] as! String
			if missleSPDStr == "N/A" {
				missleSPD = NSNumber(integer: 0)
			} else {
				missleSPD = NSNumber(integer: Int(missleSPDStr)!)
			}

			let moveSPD = NSNumber(integer: Int(jsonDictionary["move_spd"] as! String)!)
			let name = jsonDictionary["name"] as! String
			let portraitImgURL = jsonDictionary["portrait_img_url"] as! String
			let primaryAttribute = jsonDictionary["primary_attribute"] as! String
			let roles = jsonDictionary["roles"] as! String
			let sightRange = jsonDictionary["sight_range"] as! String
			let str = jsonDictionary["str"] as! String
			let abilities = jsonDictionary["abilities"] as! NSArray
			let levelAttributes = jsonDictionary["level_attributes"] as! NSArray
			
			//set hero entity
			let hero = Hero(entity: heroEntity!, insertIntoManagedObjectContext: context)
			hero.hero_id = heroID
			hero.agi = agi
			hero.armor = armor
			hero.atk_type = atkType
			hero.atk_range = atkRange
			//hero.desc = desc 
			hero.dmg = dmg
			hero.img_url = imgURL
			hero.int = int
			hero.localized_name = localizedName
			hero.lore = lore
			hero.missile_spd = missleSPD
			hero.move_spd = moveSPD
			hero.name = name
			hero.portrait_img_url = portraitImgURL
			hero.primary_attribute = primaryAttribute
			hero.roles = roles
			hero.sight_range = sightRange
			hero.str = str
			
			//set hero's abilities
			for abilityElement in abilities {
				//get ability properties
				let abilityDict = abilityElement as! NSDictionary
				var cooldown: NSNumber? = nil
				if let cooldownStr = abilityDict["coolDown"] as? String {
					cooldown = NSNumber(integer: Int(cooldownStr)!)

				} 
				let desc = abilityDict["description"] as! String
				let heroID = NSNumber(integer: Int(abilityDict["hero_id"] as! String)!)
				let imgURL = abilityDict["img_url"] as! String
				let leftDetails = abilityDict["leftDetails"] as! String
				let lore = abilityDict["lore"] as? String
				let manaCost = abilityDict["mana_cost"] as? String
				let name = abilityDict["name"] as! String
				let vidURL = abilityDict["vid_url"] as! String
				let abilityDetails = abilityDict["details"] as? NSArray
				//set ability entity
				let ability = Ability(entity: abilityEntity!, insertIntoManagedObjectContext: context)
				ability.cooldown = cooldown
				ability.desc = desc
				ability.hero_id = heroID
				ability.img_url = imgURL
				ability.left_details = leftDetails
				ability.lore = lore
				ability.mana_cost = manaCost
				ability.name = name
				ability.vid_url = vidURL
				if abilityDetails != nil {
					for detailElement in abilityDetails! {
						let detailDict = detailElement as! NSDictionary
						let name = detailDict["name"] as! String
						let detail = detailDict["detail"] as! String
						
						let abilityDetail = AbilityDetail(entity: abilityDetailEntity!, insertIntoManagedObjectContext: context)
						abilityDetail.name = name
						abilityDetail.detail = detail
						let details = ability.abilityDetails?.mutableCopy() as! NSMutableOrderedSet
						details.addObject(abilityDetail)
						ability.abilityDetails = details.copy() as? NSOrderedSet
					}

				}
				
				//set ability image hp1, hp2
				//http://cdn.dota2.com/apps/dota2/images/abilities/drow_ranger_marksmanship_hp2.png
				let abilityImageURLS = LUUtils.getAbilityImageURLS(ability.img_url)
				var imageName = LUUtils.getAbilityImageName(abilityImageURLS["hp1"]!)
				let range = imageName.rangeOfString("hp1.png")
				imageName.removeRange(range!)
				let imageHP1Name = imageName + "hp1"
				let imageHP2Name = imageName + "hp2"
				
				let hp1URL = NSBundle.mainBundle().URLForResource(imageHP1Name, withExtension: "png")
				let hp2URL = NSBundle.mainBundle().URLForResource(imageHP2Name, withExtension: "png")
				let imageHP1Data = NSData(contentsOfURL: hp1URL!)
				let imageHP2Data = NSData(contentsOfURL: hp2URL!)
				
				let abilityImage1 = AbilityImage1(entity: abilityImage1Entity!, insertIntoManagedObjectContext: context)
				abilityImage1.image = imageHP1Data!
				//abilityImage1.ability = ability 
				ability.image_hp1 = abilityImage1
				
				
				let abilityImage2 = AbilityImage2(entity: abilityImage2Entity!, insertIntoManagedObjectContext: context)
				abilityImage2.image = imageHP2Data!
				//abilityImage2.ability = ability
				ability.image_hp2 = abilityImage2
			
				//end set ability entity
				
				// put ability into hero
				let tempAbilities = hero.abilities.mutableCopy() as! NSMutableOrderedSet
				tempAbilities.addObject(ability)
				hero.abilities = tempAbilities.copy() as! NSOrderedSet
				
							
				
			}
			
			//set hero's level attributes
			for attributeElement in levelAttributes {
				let attributeDict = attributeElement as! NSDictionary
				let armor = NSNumber(float: (attributeDict["armor"] as! NSString).floatValue)
				let damage = attributeDict["damage"] as! String
				var hitPointsStr = attributeDict["hit_points"] as! String
				if let sRange = hitPointsStr.rangeOfString(",") {
					hitPointsStr.removeRange(sRange)
				}
				let hitPoints = NSNumber(integer: Int(hitPointsStr)!)
				let level = NSNumber(integer: Int(attributeDict["level"] as! String)!)
				// may contains ','
				var manaStr = attributeDict["mana"] as! String
				if let srange = manaStr.rangeOfString(",") {
					manaStr.removeRange(srange)
				}
				let mana = NSNumber(integer: Int(manaStr)!)
				
				let levelAttribute = LevelAttribute(entity: levelAttributeEntity!, insertIntoManagedObjectContext: context)
				levelAttribute.armor = armor
				levelAttribute.damage = damage
				levelAttribute.hit_points = hitPoints
				levelAttribute.level = level
				levelAttribute.mana = mana
				
				//put levelAttribute into hero
				let tempLevelAttributes = hero.levelAttributes.mutableCopy() as! NSMutableOrderedSet
				tempLevelAttributes.addObject(levelAttribute)
				hero.levelAttributes = tempLevelAttributes.copy() as! NSOrderedSet
			}
			
			// set hero's images
			//npc_dota_hero_chaos_knight to chaos_knight
			let prefix = "npc_dota_hero_"
			//var heroname = hero.name.substringFromIndex(advance(hero.name.startIndex, 14))
			let range = hero.name.rangeOfString(prefix)
			var heroname = hero.name
			heroname.removeRange(range!)
			let smallImageName = heroname + "_sb"
			let fullIamgeName = heroname + "_full"
			let largeImageName = heroname + "_lg"
			let portraitImageName = heroname + "_vert"
			let smallURL = NSBundle.mainBundle().URLForResource(smallImageName, withExtension: "png")
			let fullURL = NSBundle.mainBundle().URLForResource(fullIamgeName, withExtension: "png")
			let largeURL = NSBundle.mainBundle().URLForResource(largeImageName, withExtension: "png")
			let portraitURL = NSBundle.mainBundle().URLForResource(portraitImageName, withExtension: "jpg")
			let smallImageData = NSData(contentsOfURL: smallURL!)
			let fullImageData = NSData(contentsOfURL: fullURL!)
			let largeImageData = NSData(contentsOfURL: largeURL!)
			let portraitImageData = NSData(contentsOfURL: portraitURL!)
			
			let heroSmallImage = HeroSmallImage(entity: heroSmallImageEntity!, insertIntoManagedObjectContext: context)
			heroSmallImage.image = smallImageData!
			heroSmallImage.hero = hero
			
			let heroFullImage = HeroFullImage(entity: heroFullImageEntity!, insertIntoManagedObjectContext: context)
			heroFullImage.image = fullImageData!
			heroFullImage.hero = hero
			
			let heroLargeImage = HeroLargeImage(entity: heroLargeImageEntity!, insertIntoManagedObjectContext: context)
			heroLargeImage.image = largeImageData!
			heroLargeImage.hero = hero
			
			let heroPortraitImage = HeroPortraitImage(entity: heroPortraitImageEntity!, insertIntoManagedObjectContext: context)
			heroPortraitImage.image = portraitImageData!
			heroPortraitImage.hero = hero 
			
			
		}// end heros
		
		//coreDataStack.saveContext(context)
		print("Imported \(counter) heros into context")
		
	}

}

func setupViewControllerNavigationBarItem(controller: UIViewController, isShare: Bool) {
	let leftImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("back32", withExtension: "png")!)!)
	controller.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .Plain, target: controller, action: "dismissSelf")
	
	
	if isShare {
		let rightImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("share32", withExtension: "png")!)!)
		controller.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: controller, action: "share")
	} else {
		let rightImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("heart", withExtension: "png")!)!)
		controller.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: controller, action: "favorite")
	}
	
	controller.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
	controller.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
//	controller.navigationController?.navigationBar.barTintColor = 

}

