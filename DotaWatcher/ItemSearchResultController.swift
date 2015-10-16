//
//  ItemSearchResultController.swift
//  DotaWatcher
//
//  Created by lunner on 9/21/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit



@objc protocol ItemSearchResultControllerDelegate {
	var consumableItems: [Item]! { get  }
	var attributeItems: [Item]! { get  }
	var armamentItems: [Item]! { get  }
	var arcaneItems: [Item]! { get  }
	var commonItems: [Item]! { get  }
	var supportItems: [Item]! { get  }
	var casterItems: [Item]! { get  }
	var weaponItems: [Item]! { get  }
	var armorItems: [Item]! { get  }
	var artifactItems: [Item]! { get  }
	var secretItems: [Item]! { get }

	optional func itemSelected()
	optional func clearItemSearchBarText()
}

class ItemSearchResultController: UICollectionViewController, UISearchResultsUpdating {

	var filteredConsumableItems: [Item]!
	var filteredAttributeItems: [Item]!
	var filteredArmamentItems: [Item]!
	var filteredArcaneItems: [Item]!
	var filteredCommonItems: [Item]!
	var filteredSupportItems: [Item]!
	var filteredCasterItems: [Item]!
	var filteredWeaponItems: [Item]!
	var filteredArmorItems: [Item]!
	var filteredArtifactItems: [Item]!
	var filteredSecretItems: [Item]!
	
	var resultDelegate: ItemSearchResultControllerDelegate?
	var returnButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
     	let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
		collectionView!.registerNib(nib, forCellWithReuseIdentifier: itemCellReuseIdentifier)
		let headNib = UINib(nibName: "ItemCollectionReusableView", bundle: nil)
		collectionView!.registerNib(headNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: itemHeaderViewReuseIdentifier)
		collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: itemFooterViewReuseIdentifier)

        // Do any additional setup after loading the view.
		filteredArcaneItems = [Item]()
		filteredArmamentItems = [Item]()
		filteredArmorItems = [Item]()
		filteredArtifactItems = [Item]()
		filteredAttributeItems = [Item]()
		filteredCasterItems = [Item]()
		filteredCommonItems = [Item]()
		filteredConsumableItems = [Item]()
		filteredSecretItems = [Item]()
		filteredSupportItems = [Item]()
		filteredWeaponItems = [Item]()
		
		let buttonFrame = self.collectionView!.convertRect(CGRectMake(self.collectionView!.bounds.width/2-30.0, self.collectionView!.bounds.height, 60, 40), toView: self.view )
		returnButton = UIButton(frame: buttonFrame)
		returnButton.titleLabel?.text = "Return"
		returnButton.titleLabel?.textColor = UIColor.redColor()
		returnButton.addTarget(self, action: "returnButtonTouched", forControlEvents: UIControlEvents.TouchUpInside)
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		var sectionCount = 0
		if !filteredArcaneItems.isEmpty {
			sectionCount++
		} 
		if !filteredArmamentItems.isEmpty {
			sectionCount++
		}
		if !filteredArmorItems.isEmpty {
			sectionCount++
		}
		if !filteredArtifactItems.isEmpty {
			sectionCount++
		}
		if !filteredAttributeItems.isEmpty {
			sectionCount++
		}
		if !filteredCasterItems.isEmpty {
			sectionCount++
		}
		if !filteredCommonItems.isEmpty {
			sectionCount++
		}
		if !filteredConsumableItems.isEmpty {
			sectionCount++
		}
		if !filteredSecretItems.isEmpty {
			sectionCount++
		}
		if !filteredSupportItems.isEmpty {
			sectionCount++
		}
		if !filteredWeaponItems.isEmpty {
			sectionCount++
		}
        return sectionCount
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
	

		switch section {
		case 0:
			return filteredConsumableItems.count
		case 1:
			return filteredAttributeItems.count
		case 2:
			return filteredArmamentItems.count
		case 3:
			return filteredArcaneItems.count
		case 4:
			return filteredCommonItems.count
		case 5:
			return filteredSupportItems.count
		case 6:
			return filteredCasterItems.count
		case 7:
			return filteredWeaponItems.count
		case 8:
			return filteredArmorItems.count
		case 9:
			return filteredArtifactItems.count
		case 10:
			return filteredSecretItems.count
		default:
			return 0
		}
	}

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(itemCellReuseIdentifier, forIndexPath: indexPath) as! ItemCollectionViewCell
    
        // Configure the cell
		var smallImageData: NSData?
		switch indexPath.section {
		case 0:
			smallImageData = (filteredConsumableItems[indexPath.row].image as ItemImage).image
		case 1:
			smallImageData = (filteredAttributeItems[indexPath.row].image as ItemImage).image
		case 2:
			smallImageData = (filteredArmamentItems[indexPath.row].image as ItemImage).image
		case 3:
			smallImageData = (filteredArcaneItems[indexPath.row].image as ItemImage).image
		case 4:
			smallImageData = (filteredCommonItems[indexPath.row].image as ItemImage).image
		case 5:
			smallImageData = (filteredSupportItems[indexPath.row].image as ItemImage).image
		case 6:
			smallImageData = (filteredCasterItems[indexPath.row].image as ItemImage).image
		case 7:
			smallImageData = (filteredWeaponItems[indexPath.row].image as ItemImage).image
		case 8:
			smallImageData = (filteredArmorItems[indexPath.row].image as ItemImage).image
		case 9:
			smallImageData = (filteredArtifactItems[indexPath.row].image as ItemImage).image
		case 10:
			smallImageData = (filteredSecretItems[indexPath.row].image as ItemImage).image
		default:
			break
		}
		let image = UIImage(data: smallImageData!)
		cell.imageView.image = image

        return cell
    }
	
	override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		var reusableView: UICollectionReusableView? = nil
		if kind == UICollectionElementKindSectionHeader {
			let reusableHeaderView: ItemCollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: itemHeaderViewReuseIdentifier, forIndexPath: indexPath) as! ItemCollectionReusableView
			var title: String?
			var image: UIImage?
			
			switch indexPath.section {
			case 0:
				title = "Consumables"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_consumables", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			case 1:
				title = "Attributes"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_attributes", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			case 2:
				title = "Armaments"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_armaments", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			case 3:
				title = "Arcanes"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_arcane", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			case 4:
				title = "Commons"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_common", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			case 5:
				title = "Supports"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_support", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			case 6:
				title = "Casters"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_caster", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			case 7:
				title = "Weapons"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_weapons", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			case 8:
				title = "Armors"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_armor", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
				
			case 9:
				title = "Artifacts"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_artifacts", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			case 10:
				title = "Secrets"
				let imageURL = NSBundle.mainBundle().URLForResource("itemcat_secret", withExtension: "png")
				image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			default:
				break;
			}
			
			reusableHeaderView.label.text = title
			reusableHeaderView.imageView.image = image
			reusableView = reusableHeaderView
		}
		if kind == UICollectionElementKindSectionFooter {
			let reusableFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: itemFooterViewReuseIdentifier, forIndexPath: indexPath) 
			reusableView = reusableFooterView
		}
		return reusableView!
		
	}

	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if resultDelegate?.itemSelected != nil {
			resultDelegate?.itemSelected!()
		}
	}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
	
	// MARK: search
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		if !searchController.active {
			return
		}
		self.filterContentForSearchText(searchController.searchBar.text!)
	}
	
	func filterContentForSearchText(searchText: String) {
		let predicate = NSPredicate(format: "SELF.localized_name contains[c] %@", searchText)
		filteredArcaneItems = (self.resultDelegate!.arcaneItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredArmamentItems = (self.resultDelegate!.armamentItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredArmorItems = (self.resultDelegate!.armorItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredArtifactItems = (self.resultDelegate!.artifactItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredAttributeItems = (self.resultDelegate!.attributeItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredCasterItems = (self.resultDelegate!.casterItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredCommonItems = (self.resultDelegate!.commonItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredConsumableItems = (self.resultDelegate!.consumableItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredSecretItems = (self.resultDelegate!.secretItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredSupportItems = (self.resultDelegate!.supportItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		filteredWeaponItems = (self.resultDelegate!.weaponItems as NSArray).filteredArrayUsingPredicate(predicate) as! [Item]
		
		collectionView?.reloadData()
		
		
	}
	
	func returnButtonTouched(sender: AnyObject!) {
		self.dismissViewControllerAnimated(true, completion: {
			[unowned self] in
			if self.resultDelegate?.clearItemSearchBarText != nil {
				self.resultDelegate?.clearItemSearchBarText!()
			}
		})
	}

}
