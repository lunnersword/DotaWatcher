//
//  HerosAndItemsViewController.swift
//  DotaWatcher
//
//  Created by lunner on 9/15/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import UIKit
import CoreData

enum HeroAttackType: String {
	case All = "All"
	case Melee = "Melee"	//near
	case Ranged = "Ranged"	//far
}
//Initiator - Disabler - Nuker - Durable
enum HeroRole: String {
	case All = "All"
	case Carry = "Carry"	//爆发
	case Disabler = "Disabler"	//控制
	case LaneSupport = "Lane Support"	//对线辅助 none
	case Initiator = "Initiator"	//先手
	case Jungler = "Jungler"	//打野
	case Support = "Support"	//辅助
	case Durable = "Durable"	//耐久
	case Nuker = "Nuker"	//核心
	case Pusher = "Pusher"	//推进
	case Escape = "Escape"	//逃生
}

enum ItemCategory: String {
	case Consumable = "Consumable"
	case Attribute = "Attribute"
	case Armament = "Armament"
	case Arcane = "Arcane"
	case Common = "Common"
	case Support = "Support"
	case Caster = "Caster"
	case Weapon = "Weapon"
	case Armor = "Armor"
	case Artifact = "Artifact"
	case Secret = "Secret"
}
let consumables = ["clarity", "enchanted_mango", "tango", "flask", "smoke_of_deceit", "tpscroll", "dust", "courier", "flying_courier", "ward_observer", "ward_sentry", "bottle"]//12
let attributes = ["branches", "gauntlets", "slippers", "mantle", "circlet", "belt_of_strength", "boots_of_elves", "robe", "ogre_axe", "blade_of_alacrity", "staff_of_wizardry"]//11
let armaments = ["ring_of_protection", "stout_shield", "quelling_blade", "orb_of_venom", "blades_of_attack", "chainmail", "quarterstaff", "helm_of_iron_will", "broadsword", "claymore", "javelin", "mithril_hammer"]//12
let arcanes = ["magic_stick", "sobi_mask", "ring_of_regen", "boots",  "gloves", "cloak", "ring_of_health", "void_stone", "gem", "lifesteal", "shadow_amulet", "ghost", "blink"]//13
let commons = ["magic_wand", "null_talisman", "wraith_band", "poor_mans_shield", "bracer", "soul_ring", "phase_boots", "power_treads", "oblivion_staff", "pers", "hand_of_midas", "travel_boots", "moon_shard"]
let supports = ["ring_of_basilius", "headdress", "buckler", "urn_of_shadows", "tranquil_boots", "ring_of_aquila", "medallion_of_courage", "arcane_boots", "ancient_janggo", "mekansm", "vladmir", "pipe", "guardian_greaves"]
let casters = ["glimmer_cape", "force_staff", "veil_of_discord", "necronomicon", "dagon", "cyclone", "solar_crest", "rod_of_atos", "orchid", "ultimate_scepter", "refresher", "sheepstick", "octarine_core"]
let weapons = ["lesser_crit", "armlet", "invis_sword", "basher", "bfury", "ethereal_blade", "silver_edge", "radiance", "monkey_king_bar", "greater_crit", "butterfly", "rapier", "abyssal_blade"]
let armors = ["hood_of_defiance", "vanguard", "blade_mail", "soul_booster", "crimson_guard", "black_king_bar", "lotus_orb", "shivas_guard", "bloodstone", "manta", "sphere", "assault", "heart"]
let artifacts = ["mask_of_madness", "helm_of_the_dominator", "sange", "yasha", "maelstrom", "diffusal_blade", "desolator", "heavens_halberd", "sange_and_yasha", "skadi", "mjollnir", "satanic"]//12
let secrets = ["energy_booster", "point_booster", "vitality_booster", "platemail", "talisman_of_evasion", "hyperstone", "ultimate_orb", "demon_edge", "mystic_staff", "reaver", "eagle", "relic"]//12
/*
enum ItemQual: String {
	case Consumable = "consumable"
	case Attribute
}*/

class HerosAndItemsViewController: UIViewController, HeroSearchResultControllerDelegate, HeroCollectionViewDelegate, ItemCollectionViewDelegate, ItemSearchResultControllerDelegate, HeroFilterDelegate, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate {
	@IBOutlet weak var herosButton: UIButton!
	@IBOutlet weak var itemsButton: UIButton!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
	
	var heroCollectionViewController: HeroCollectionViewController!
	var itemCollectionViewController: ItemCollectionViewController!
	var buttonIndicator: UIView!
	
	var heroSearchController: UISearchController? = nil
	var itemSearchController: UISearchController? = nil
	var heroCategoryFilter: UIButton? = nil
	
	var strengthHeros: [Hero]!
	var agilityHeros: [Hero]!
	var intelligenceHeros: [Hero]!
	
	var filteredStrengthHeros: [Hero]! = [Hero]()
	var filteredAgilityHeros: [Hero]! = [Hero]()
	var filteredIntelligenceHeros: [Hero]! = [Hero]()
	
	var consumableItems: [Item]! = [Item]()
	var attributeItems: [Item]! = [Item]()
	var armamentItems: [Item]! = [Item]()
	var arcaneItems: [Item]! = [Item]()
	var commonItems: [Item]! = [Item]()
	var supportItems: [Item]! = [Item]()
	var casterItems: [Item]! = [Item]()
	var weaponItems: [Item]! = [Item]()
	var armorItems: [Item]! = [Item]()
	var artifactItems: [Item]! = [Item]()
	var secretItems: [Item]! = [Item]()
	
		
	var coreDataStack: CoreDataStack?
	
	lazy var strengthHeroPredicate: NSPredicate = {
		var predicate = NSPredicate(format: "primary_attribute == %@", "str")
		return predicate
	}()
	
	lazy var agilityHeroPredicate: NSPredicate = {
		var predicate = NSPredicate(format: "primary_attribute == %@", "agi")
		return predicate
	}()
	
	lazy var intelligenceHeroPredicate: NSPredicate = {
		var predicate = NSPredicate(format: "primary_attribute == %@", "int")
		return predicate
	}()
	
	lazy var localNameSortDescriptor: NSSortDescriptor = {
		var sd = NSSortDescriptor(key: "localized_name", ascending: true, selector: "localizedStandardCompare:")
		return sd
	}()
	
	var consumableItemPredicate: NSPredicate  {
		 get {
			var consumableItems = [String]()
			for item in consumables {
				consumableItems.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", consumableItems)

		}
	}
	
	
	var secretItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in secrets {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}
	
	var artifactItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in artifacts {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}
	
	var armorItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in armors {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}
	var weaponItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in weapons {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}
	
	var casterItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in casters {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}
	var supportItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in supports {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}
	
	var commonItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in commons {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}

	var attributeItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in attributes {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}
	var armamentItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in armaments {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}
	var arcaneItemPredicate: NSPredicate {
		get {
			var items = [String]()
			for item in arcanes {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)
		}
	}
	

	//lazy var attributeItemPredicate
	
	var heroButtonSelected: Bool = true // TODO: heroButtonSelected
	var haveCalledAfterHeroAndItemLoaded = false
	var viewInitializationDone = false
	
	var lastContentOffset: CGPoint = CGPointZero
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
		
		//herosButton.tag = 0
		//itemsButton.tag = 1
		
		
		configureActivityIndicator()
		

		scrollView.pagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.bounces = true
		scrollView.directionalLockEnabled = true
		scrollView.alwaysBounceHorizontal = true
		scrollView.alwaysBounceVertical = false
		scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width*2.0, 0)
		scrollView.contentInset = UIEdgeInsetsMake(3.0, 5.0, 3.0, 5.0)
		scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
		scrollView.scrollEnabled = true
		scrollView.delegate = self

		
		buttonIndicator = UIView()
		buttonIndicator.backgroundColor = UIColor.redColor()
		self.view.addSubview(buttonIndicator)
		self.view.bringSubviewToFront(buttonIndicator)
		
		initScrollSubViews()
		
		let isFirstLaunch = NSUserDefaults.standardUserDefaults().boolForKey(Preferece.IsFirstLaunch.rawValue)
		if !isFirstLaunch {
			print("Is not first launch, loading datas...")
			initializationAfterCoreDataIsReady()
		} else {
			print("Is first launch")
			//if needCallAfterHeroAndItemLoaded {
		
			initializationAfterCoreDataIsReady()
			//}
		}
		
		
    }
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if !self.viewInitializationDone {
			self.viewInitializationDone = true
					
			if heroButtonSelected {
				adjustViewsToHeroButton()
			} else {
				adjustViewsToItemButton()
			}
		

			updateScrollSubViews()
		
		} else {
			print("view did layout subviews")
			if heroButtonSelected {
				adjustViewsToHeroButton(false)
			} else {
				adjustViewsToItemButton(false)
			}
		}
	

	}
	
	func initScrollSubViews() {
		addHeroSearchBar()
		let heroFlowLayout = CollectionViewFlowLayout(itemSize: CGSizeMake(59, 33), headHeight: 33)
		heroFlowLayout.invalidateLayout()
		heroCollectionViewController = HeroCollectionViewController(collectionViewLayout: heroFlowLayout)
		self.addChildViewController(heroCollectionViewController)
		heroCollectionViewController.view.frame = CGRectMake(3, 45, scrollView.bounds.width-6, scrollView.bounds.height-45)
//		let heroLeftConstraint = NSLayoutConstraint(item: heroCollectionViewController.view, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 3.0)
//		let heroTopConstraint = NSLayoutConstraint(item: heroCollectionViewController.view, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 45.0)
//		let heroWidthConstraint = NSLayoutConstraint(item: heroCollectionViewController.view, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -6.0)
//		let heroHeightConstraint = NSLayoutConstraint(item: heroCollectionViewController.view, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: -45.0)
		
		self.scrollView.addSubview(heroCollectionViewController.view)
//		heroCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
//		scrollView.addConstraints([heroLeftConstraint, heroTopConstraint, heroWidthConstraint, heroHeightConstraint])
		self.scrollView.bringSubviewToFront(heroCollectionViewController.view)
		heroCollectionViewController.heroDelegate = self


		
		addItemSearchBar()
		let itemFlowLayout = CollectionViewFlowLayout(itemSize: CGSizeMake(85, 64), headHeight: 49)
		itemFlowLayout.invalidateLayout()
		itemCollectionViewController = ItemCollectionViewController(collectionViewLayout: itemFlowLayout)
		self.addChildViewController(itemCollectionViewController)
		self.scrollView.addSubview(itemCollectionViewController.view)
		itemCollectionViewController.view.frame = CGRectMake(scrollView.bounds.width+3, 45, scrollView.bounds.width-6, scrollView.bounds.height-45)
//		let itemLeftConstraint = NSLayoutConstraint(item: itemCollectionViewController.view, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1.0, constant: 3.0)
//		let itemTopConstraint = NSLayoutConstraint(item: itemCollectionViewController.view, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 45)
//		let itemWidthConstraint = NSLayoutConstraint(item: itemCollectionViewController.view, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -6.0)
//		let itemHeightConstraint = NSLayoutConstraint(item: itemCollectionViewController.view, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: -45.0)
//		itemCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
//		scrollView.addConstraints([itemLeftConstraint, itemTopConstraint, itemWidthConstraint, itemHeightConstraint])
		self.scrollView.bringSubviewToFront(itemCollectionViewController.view)
		self.itemCollectionViewController.itemDelegate = self
		
	}
	
	func addHeroSearchBar() {

		//self.heroCategoryFilter = UIButton()
		self.heroCategoryFilter = UIButton(frame: CGRectMake(3.0, 0.0, 120.0, 40.0))
		self.heroCategoryFilter?.setTitle("分类检索", forState: .Normal)
		self.heroCategoryFilter?.addTarget(self, action: "presentHeroFilters", forControlEvents: .TouchUpInside)
		self.scrollView.addSubview(heroCategoryFilter!)
//		heroCategoryFilter!.translatesAutoresizingMaskIntoConstraints = false
//		self.scrollView.addConstraint(NSLayoutConstraint(item: heroCategoryFilter!, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 3.0))
//		self.scrollView!.addConstraint(NSLayoutConstraint(item: heroCategoryFilter!, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 0))
//		heroCategoryFilter!.addConstraint(NSLayoutConstraint(item: heroCategoryFilter!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 120.0))
//		heroCategoryFilter!.addConstraint(NSLayoutConstraint(item: heroCategoryFilter!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0))
		
		
		let heroFlowLayout = CollectionViewFlowLayout(itemSize: CGSizeMake(59, 33), headHeight: 33)
		heroFlowLayout.invalidateLayout()
		
		let heroResultsController = HeroSearchResultController(collectionViewLayout: heroFlowLayout)
		heroResultsController.resultDelegate = self
		heroSearchController = UISearchController(searchResultsController: heroResultsController)
		heroSearchController!.searchResultsUpdater = heroResultsController
		self.scrollView.addSubview(heroSearchController!.searchBar)
		heroSearchController!.searchBar.frame = CGRectMake(126, 0, self.scrollView.bounds.width-129, 40.0)
//		heroSearchController!.searchBar.translatesAutoresizingMaskIntoConstraints = false
//		let leftConstraint = NSLayoutConstraint(item: heroSearchController!.searchBar, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 126.0)
//		let topConstraint = NSLayoutConstraint(item: heroSearchController!.searchBar, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 0.0)
//		let widthConstraint = NSLayoutConstraint(item: heroSearchController!.searchBar, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -129.0)
//		let heightConstraint = NSLayoutConstraint(item: heroSearchController!.searchBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0)
//		scrollView.addConstraints([leftConstraint, topConstraint, widthConstraint, heightConstraint])
		
		self.definesPresentationContext = true
	}
	
	func addItemSearchBar() {
		let itemFlowLayout = CollectionViewFlowLayout(itemSize: CGSizeMake(85, 64), headHeight: 49)
		itemFlowLayout.invalidateLayout()
		let itemResultsController = ItemSearchResultController(collectionViewLayout: itemFlowLayout)
		itemResultsController.resultDelegate = self
		itemSearchController = UISearchController(searchResultsController: itemResultsController)
		itemSearchController!.searchResultsUpdater = itemResultsController
		itemSearchController!.searchBar.frame = CGRectMake(scrollView.bounds.width + 3.0, 0, scrollView.bounds.width-6.0, 40.0)
		
		self.scrollView.addSubview(itemSearchController!.searchBar)
//		itemSearchController!.searchBar.translatesAutoresizingMaskIntoConstraints = false
//		let leftConstraint = NSLayoutConstraint(item: itemSearchController!.searchBar, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: ., multiplier: 1.0, constant: 3.0)
//		let topConstraint = NSLayoutConstraint(item: itemSearchController!.searchBar, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 0.0)
//		let widthConstraint = NSLayoutConstraint(item: itemSearchController!.searchBar, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: -6.0)
//		let heightConstraint = NSLayoutConstraint(item: itemSearchController!.searchBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0)
//		scrollView!.addConstraints([leftConstraint, topConstraint, widthConstraint, heightConstraint])
		
		self.definesPresentationContext = true
		
	}

	
	func updateScrollSubViews() {
		heroSearchController!.searchBar.frame = CGRectMake(126, 0, self.scrollView.bounds.width-129, 40.0)
		heroCollectionViewController.view.frame = CGRectMake(3, 45, scrollView.bounds.width-6, scrollView.bounds.height-45)
		
		itemSearchController!.searchBar.frame = CGRectMake(scrollView.bounds.width + 3.0, 0, scrollView.bounds.width-6.0, 40.0)
		itemCollectionViewController.view.frame = CGRectMake(scrollView.bounds.width+3, 45, scrollView.bounds.width-6, scrollView.bounds.height-45)
		

	}
	
	
	func initializationAfterCoreDataIsReady() {
		
		NSUserDefaults.standardUserDefaults().setBool(false, forKey: Preferece.IsFirstLaunch.rawValue)
		if !haveCalledAfterHeroAndItemLoaded {
			print("Start loading...")
			loadHeros()
			loadFilteredHeros(roles: [])

			loadItems()
			activityIndicator.stopAnimating()
			haveCalledAfterHeroAndItemLoaded = true

			//initScrollSubViews()

			//self.scrollView.bringSubviewToFront(heroCollectionViewController.view)
			//self.scrollView.bringSubviewToFront(itemCollectionViewController.view)
		}
	}
	
	func configureActivityIndicator() {

		activityIndicator.activityIndicatorViewStyle = .WhiteLarge
		activityIndicator.color = UIColor.greenColor()
		activityIndicator.startAnimating()
		activityIndicator.hidesWhenStopped = true
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
	
	func adjustViewsToHeroButton(withScroll: Bool = true) {
		self.buttonIndicator.frame = self.herosButton.convertRect(CGRectMake(0, self.herosButton.bounds.height, self.herosButton.bounds.width, 3.0), toView: self.view )
		let frame = CGRectMake(self.scrollView.bounds.width/2-30, self.scrollView.bounds.height/2-30, 60, 60)
		self.activityIndicator.frame = frame
		if withScroll {
			self.scrollView.contentOffset = CGPointMake(0, 0)
		}
	}
	
	func adjustViewsToItemButton(withScroll: Bool = true) {
		self.buttonIndicator.frame = self.itemsButton.convertRect(CGRectMake(0, self.itemsButton.bounds.height, self.itemsButton.bounds.width, 3.0), toView: self.view)
		let frame = CGRectMake(self.scrollView.bounds.width + self.scrollView.bounds.width/2-30, self.scrollView.bounds.height/2-30, 60, 60)
		self.activityIndicator.frame = frame
		if withScroll {
			self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.width, 0)
		}
	}
	// MARK: Actions

	@IBAction func topTapButtonTouched(sender: UIButton) {
		if sender.tag == 0 {
			heroButtonSelected = true
			UIView.animateWithDuration(0.5, animations: {
				[unowned self] in
				self.adjustViewsToHeroButton();
			})
			
		} else if sender.tag == 1 {
			heroButtonSelected = false
			UIView.animateWithDuration(0.5, animations: {
				[unowned self] in
				self.adjustViewsToItemButton()
			})
			
		}
	}

	// MARK: scrollView delegate
//	func scrollViewDidScroll(scrollView: UIScrollView) {
//		print("scroll in scrollView")
////		
////		if(scrollView.isKindOfClass(UICollectionView.self)){
////			return
////		}
//
//		
//		switch scrollView.contentOffset {
//		case  CGPointMake(0, 0):
//			//adjustViewsToHeroButton() just update indicatorbutton
//			print("ScrollViewdDidScrollbut1")
//			heroButtonSelected = true
//			self.buttonIndicator.frame = self.herosButton.convertRect(CGRectMake(0, self.herosButton.bounds.height, self.herosButton.bounds.width, 3.0), toView: self.view )
//			let frame = CGRectMake(self.scrollView.bounds.width/2-30, self.scrollView.bounds.height/2-30, 60, 60)
//			self.activityIndicator.frame = frame
//		case CGPointMake(scrollView.bounds.width, 0):
//			//adjustViewsToItemButton()
//			print("ScrollViewdDidScrollbtn2")
//			heroButtonSelected = false
//			self.buttonIndicator.frame = self.itemsButton.convertRect(CGRectMake(0, self.itemsButton.bounds.height, self.itemsButton.bounds.width, 3.0), toView: self.view)
//			let frame = CGRectMake(self.scrollView.bounds.width + self.scrollView.bounds.width/2-30, self.scrollView.bounds.height/2-30, 60, 60)
//			self.activityIndicator.frame = frame
//		default:
//			break;
//		}
//	}
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		lastContentOffset = scrollView.contentOffset
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let currentContentOffset = scrollView.contentOffset
		let vector = currentContentOffset - lastContentOffset
		if vector.x.sign() == -1.0 {
			// drag to right
			print("ScrollViewdDidScrollbut1")
			heroButtonSelected = true
			self.buttonIndicator.frame = self.herosButton.convertRect(CGRectMake(0, self.herosButton.bounds.height, self.herosButton.bounds.width, 3.0), toView: self.view )
			let frame = CGRectMake(self.scrollView.bounds.width/2-30, self.scrollView.bounds.height/2-30, 60, 60)
			self.activityIndicator.frame = frame

		} else {
			print("ScrollViewdDidScrollbtn2")
			heroButtonSelected = false
			self.buttonIndicator.frame = self.itemsButton.convertRect(CGRectMake(0, self.itemsButton.bounds.height, self.itemsButton.bounds.width, 3.0), toView: self.view)
			let frame = CGRectMake(self.scrollView.bounds.width + self.scrollView.bounds.width/2-30, self.scrollView.bounds.height/2-30, 60, 60)
			self.activityIndicator.frame = frame
		}
	}
	
	/*
	func getItemCategoryPredicate(category: ItemCategory) -> NSPredicate {
		switch category {
		case .Arcane:
			var items = [String]()
			for item in arcanes {
				items.append("item_"+item)
			}
			return NSPredicate(format: "name IN %@", items)

			
		}
	}*/
	// MARK: Load Heros and Items
	func loadItemsByPredicate(predicate: NSPredicate) -> [Item] {
		let fetchRequest = NSFetchRequest(entityName: "Item")
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = [localNameSortDescriptor]
		
		//let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
		// coreDataStack as a property is more conveient for test
		do {
			let result = try coreDataStack!.mainContext.executeFetchRequest(fetchRequest) as! [Item]
			return result
		} catch {
			print("\(error)")
		}
		return [Item]()

	}
	func loadHerosByPredicate(predicate: NSPredicate) -> [Hero] {
		let fetchRequest = NSFetchRequest(entityName: "Hero")
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = [localNameSortDescriptor]
		
		//let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
		do {
			let result = try coreDataStack!.mainContext.executeFetchRequest(fetchRequest) as! [Hero]
			return result
		} catch {
			print("\(error)")
		}
		return [Hero]()
		
	}
	
	func loadHeros() {
		self.strengthHeros = loadHerosByPredicate(strengthHeroPredicate)
		self.agilityHeros = loadHerosByPredicate(agilityHeroPredicate)
		self.intelligenceHeros = loadHerosByPredicate(intelligenceHeroPredicate)
		print("heros loaded")
	}
	func heroFilterChanged(attackType: HeroAttackType, roles: [HeroRole]) {
		loadFilteredHeros(attackType: attackType, roles: roles)
	}
	func loadFilteredHeros(attackType attackType: HeroAttackType = .All, roles: [HeroRole]) {
		var tempStrengHeros = strengthHeros
		var tempAgilityHeros = agilityHeros
		var tempIntelligenceHeros = intelligenceHeros
		let attackTypePredicate: NSPredicate?
		if attackType == .All {
			attackTypePredicate = nil
		} else {
			attackTypePredicate = NSPredicate(format: "atk_type == %@", attackType.rawValue)
		}
		if attackTypePredicate != nil {
			tempStrengHeros = (tempStrengHeros as NSArray).filteredArrayUsingPredicate(attackTypePredicate!) as! [Hero]
			tempAgilityHeros = (tempAgilityHeros as NSArray).filteredArrayUsingPredicate(attackTypePredicate!) as! [Hero]
			tempIntelligenceHeros = (tempIntelligenceHeros as NSArray).filteredArrayUsingPredicate(attackTypePredicate!) as! [Hero]
		}
		var rolePredicate: NSPredicate?
		for role in roles {
			switch role {
			case .All:
				rolePredicate = nil
			case .Carry:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.Carry.rawValue)
			case .Disabler:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.Disabler.rawValue)
			case .Durable:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.Durable.rawValue)
			case .Escape:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.Escape.rawValue)
			case .Initiator:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.Initiator.rawValue)
			case .Jungler:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.Jungler.rawValue)
			case .LaneSupport:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.LaneSupport.rawValue)
			case .Nuker:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.Nuker.rawValue)
			case .Pusher:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.Pusher.rawValue)
			case .Support:
				rolePredicate = NSPredicate(format: "roles contains[c] %@", HeroRole.Support.rawValue)
			}
			if rolePredicate != nil {
				tempStrengHeros = (tempStrengHeros as NSArray).filteredArrayUsingPredicate(rolePredicate!) as! [Hero]
				tempAgilityHeros = (tempAgilityHeros as NSArray).filteredArrayUsingPredicate(rolePredicate!) as! [Hero]
				tempIntelligenceHeros = (tempIntelligenceHeros as NSArray).filteredArrayUsingPredicate(rolePredicate!) as! [Hero]
			}
			
		}
		filteredStrengthHeros = tempStrengHeros
		filteredAgilityHeros = tempAgilityHeros
		filteredIntelligenceHeros = tempIntelligenceHeros
		
	}
	func loadItems() {
		consumableItems = loadItemsByPredicate(consumableItemPredicate)
		attributeItems = loadItemsByPredicate(attributeItemPredicate)
		armamentItems = loadItemsByPredicate(armamentItemPredicate)
		arcaneItems = loadItemsByPredicate(arcaneItemPredicate)
		commonItems = loadItemsByPredicate(commonItemPredicate)
		supportItems = loadItemsByPredicate(supportItemPredicate)
		casterItems = loadItemsByPredicate(casterItemPredicate)
		weaponItems = loadItemsByPredicate(weaponItemPredicate)
		armorItems = loadItemsByPredicate(armorItemPredicate)
		artifactItems = loadItemsByPredicate(artifactItemPredicate)
		secretItems = loadItemsByPredicate(secretItemPredicate)
		print("items loaded")
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
	
	// MARK: Presentations
	
	func presentHeroFilters() {
		print("HeroCategoryFilters Button touched")
		/*let heroFilterCtr = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HeroFilterViewController") as! HeroFilterViewController
		heroFilterCtr.delegate = self
		heroFilterCtr.modalPresentationStyle = UIModalPresentationStyle.Popover
		let filterPopover = heroFilterCtr.popoverPresentationController
		filterPopover?.delegate = self
		filterPopover?.sourceView = self.heroCategoryFilter
		filterPopover?.sourceRect = (self.heroCategoryFilter?.bounds)!
		filterPopover?.permittedArrowDirections = .Any
		presentViewController(heroFilterCtr, animated: true, completion: nil)
*/
		
	}
	
	
	// MARK: UIPopoverPresentationControllerDelegate 
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}
	func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
		let navController = UINavigationController(rootViewController: controller.presentedViewController)
		return navController
	}
	
	func filterHerosByCategory(heroRole heroRole: HeroRole, attackType: HeroAttackType) {
		
	}
	func presentHeroViewController(hero: Hero?) {
		print("Hero selected")
		if	hero == nil {
			return
		}
		let navigationCrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HeroDetailNavigationCotroller") as! UINavigationController
		
		let heroDetailViewCrl = navigationCrl.childViewControllers[0] as! HeroDetailViewController
//		let heroDetailViewCrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HeroDetailViewController") as! HeroDetailViewController
		heroDetailViewCrl.hero = hero
		//heroDetailViewCrl.toolbarItem
//		heroDetailViewCrl.modalPresentationStyle = .FullScreen
//		heroDetailViewCrl.modalTransitionStyle = .FlipHorizontal
		navigationCrl.modalPresentationStyle = .FullScreen
		navigationCrl.modalTransitionStyle = .FlipHorizontal
		showViewController(navigationCrl, sender: self)
		
 
		
	}
	func presentItemViewController() {
		
	}
	func heroSelected(indexPath: NSIndexPath) {
		var hero: Hero?
		switch indexPath.section {
		case 0:
			hero = filteredStrengthHeros[indexPath.row]
		case 1:
			hero = filteredAgilityHeros[indexPath.row]
		case 2:
			hero = filteredIntelligenceHeros[indexPath.row]
		default:
			break
		}
		presentHeroViewController(hero)
	}
	func searchHeroSelected() {
		//presentHeroViewController()
	}
	func clearHeroSearchBarText() {
		
	}
	
	func itemSelected() {
		presentItemViewController()
	}
	func clearItemSearchBarText() {
		
	}
	
	func rootContextDidSave(notifcation: NSNotification) {
		self.initializationAfterCoreDataIsReady()
	}
}
