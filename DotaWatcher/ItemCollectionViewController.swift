//
//  ItemCollectionViewController.swift
//  DotaWatcher
//
//  Created by lunner on 9/20/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit

@objc protocol ItemCollectionViewDelegate {
	var consumableItems: [Item]! { get set }
	var attributeItems: [Item]! { get set }
	var armamentItems: [Item]! { get set }
	var arcaneItems: [Item]! { get set }
	var commonItems: [Item]! { get set }
	var supportItems: [Item]! { get set }
	var casterItems: [Item]! { get set }
	var weaponItems: [Item]! { get set }
	var armorItems: [Item]! { get set }
	var artifactItems: [Item]! { get set }
	var secretItems: [Item]! { get set }
	optional func itemSelected()

}

let itemCellReuseIdentifier = "ItemCell"
let itemHeaderViewReuseIdentifier = "ItemHeaderView"
let itemFooterViewReuseIdentifier = "ItemFooterView"

class ItemCollectionViewController: UICollectionViewController {

	var itemDelegate: ItemCollectionViewDelegate!

	
	override init(collectionViewLayout layout: UICollectionViewLayout) {
		
		super.init(collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
		
		self.collectionView!.registerClass(ItemCollectionViewCell.self, forCellWithReuseIdentifier: itemCellReuseIdentifier)
		let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
		collectionView!.registerNib(nib, forCellWithReuseIdentifier: itemCellReuseIdentifier)
		collectionView!.backgroundColor = UIColor.blackColor()
		
		let headNib = UINib(nibName: "ItemCollectionReusableView", bundle: nil)
		collectionView!.registerNib(headNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: itemHeaderViewReuseIdentifier)
		collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: itemFooterViewReuseIdentifier)
		
		//self.collectionView?.delegate = self;

        // Do any additional setup after loading the view.
		/*let flowLayout = CollectionViewFlowLayout(itemSize: CGSizeMake(85, 64), headHeight: 49)
		flowLayout.invalidateLayout()
		collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
		//collectionView?.setCollectionViewLayout(flowLayout, animated: false)
		collectionView?.reloadData()
		*/
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
		if !itemDelegate.consumableItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.attributeItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.armamentItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.arcaneItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.commonItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.supportItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.casterItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.weaponItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.armorItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.artifactItems.isEmpty {
			sectionCount++
		}
		if !itemDelegate.secretItems.isEmpty {
			sectionCount++
		}
		
		
        return sectionCount
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		
		switch section {
		case 0:
			return itemDelegate.consumableItems.count
		case 1:
			return itemDelegate.attributeItems.count
		case 2:
			return itemDelegate.armamentItems.count
		case 3:
			return itemDelegate.arcaneItems.count
		case 4:
			return itemDelegate.commonItems.count
		case 5:
			return itemDelegate.supportItems.count
		case 6:
			return itemDelegate.casterItems.count
		case 7:
			return itemDelegate.weaponItems.count
		case 8:
			return itemDelegate.armorItems.count
		case 9:
			return itemDelegate.artifactItems.count
		case 10:
			return itemDelegate.secretItems.count
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
			smallImageData = (itemDelegate.consumableItems[indexPath.row].image as ItemImage).image
		case 1:
			smallImageData = (itemDelegate.attributeItems[indexPath.row].image as ItemImage).image
		case 2:
			smallImageData = (itemDelegate.armamentItems[indexPath.row].image as ItemImage).image
		case 3:
			smallImageData = (itemDelegate.arcaneItems[indexPath.row].image as ItemImage).image
		case 4:
			smallImageData = (itemDelegate.commonItems[indexPath.row].image as ItemImage).image
		case 5:
			smallImageData = (itemDelegate.supportItems[indexPath.row].image as ItemImage).image
		case 6:
			smallImageData = (itemDelegate.casterItems[indexPath.row].image as ItemImage).image
		case 7:
			smallImageData = (itemDelegate.weaponItems[indexPath.row].image as ItemImage).image
		case 8:
			smallImageData = (itemDelegate.armorItems[indexPath.row].image as ItemImage).image
		case 9:
			smallImageData = (itemDelegate.artifactItems[indexPath.row].image as ItemImage).image
		case 10:
			smallImageData = (itemDelegate.secretItems[indexPath.row].image as ItemImage).image
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
		if itemDelegate?.itemSelected != nil {
			itemDelegate!.itemSelected!()
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
	
	
	
}
