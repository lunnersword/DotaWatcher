//
//  HeroSearchResultControllerCollectionViewController.swift
//  DotaWatcher
//
//  Created by lunner on 9/15/15.
//  Copyright (c) 2015 lunner. All rights reserved.
//

import UIKit

let heroReuseIdentifier = "HeroCell"
let heroReuseViewIdentifier = "HeroHeaderView"
@objc protocol HeroSearchResultControllerDelegate {
	var filteredStrengthHeros: [Hero]! { get }
	var filteredAgilityHeros: [Hero]! { get }
	var filteredIntelligenceHeros: [Hero]! { get }

	optional func searchHeroSelected()
	optional func clearHeroSearchBarText()
}

class HeroSearchResultController: UICollectionViewController, UISearchResultsUpdating {
	var strengthHeros: [Hero]!
	var agilityHeros: [Hero]!
	var intelligenceHeros: [Hero]!
	var filteredStrengthHeros: [Hero]! = [Hero]()
	var filteredAgilityHeros: [Hero]! = [Hero]()
	var filteredIntelligenceHeros: [Hero]! = [Hero]()
	var resultDelegate: HeroSearchResultControllerDelegate?
	var returnButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
		self.strengthHeros = resultDelegate?.filteredStrengthHeros
		self.agilityHeros = resultDelegate?.filteredAgilityHeros
		self.intelligenceHeros = resultDelegate?.filteredIntelligenceHeros


        // Do any additional setup after loading the view.
	
		
		let buttonFrame = self.collectionView?.convertRect(CGRectMake(self.collectionView!.bounds.width/2-30.0, self.collectionView!.bounds.height, 60, 40), toView: self.view)
		returnButton = UIButton(frame: buttonFrame!)
		returnButton.titleLabel?.text = "Return"
		returnButton.titleLabel?.textColor = UIColor.redColor()
		returnButton.addTarget(self, action: "returnButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
		
		let nib = UINib(nibName: "HeroCollectionViewCell", bundle: nil)
		collectionView?.registerNib(nib, forCellWithReuseIdentifier: heroReuseIdentifier)
		let headNib = UINib(nibName: "HeroCollectionReusableView", bundle: nil)
		collectionView?.registerNib(headNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: heroReuseViewIdentifier)
		collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
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
        //#warning Incomplete method implementation -- Return the number of sections
		var sectionCount = 0
		if !filteredAgilityHeros.isEmpty {
			sectionCount += 1
		} 
		if !filteredStrengthHeros.isEmpty {
			sectionCount += 1
		}
		if !filteredIntelligenceHeros.isEmpty {
			sectionCount += 1
		}
		return sectionCount

    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
		switch section {
		case 0:
			return filteredStrengthHeros!.count
		case 1:
			return filteredAgilityHeros!.count
		case 2:
			return filteredIntelligenceHeros!.count
		default:
			return 0
		}
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(heroReuseIdentifier, forIndexPath: indexPath) as! HeroCollectionViewCell
		var smallImageData: NSData?
		switch indexPath.section {
		case 0:
			smallImageData = (filteredStrengthHeros[indexPath.row].smallImage as HeroSmallImage).image
		case 1:
			smallImageData = (filteredAgilityHeros[indexPath.row].smallImage as HeroSmallImage).image
		case 2:
			smallImageData = (filteredIntelligenceHeros[indexPath.row].smallImage as HeroSmallImage).image
		default:
			break
		}
    
        // Configure the cell
		let smallImage = UIImage(data: smallImageData!)
		cell.imageView.image = smallImage

        return cell
    }
	
	override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		var reusableView: UICollectionReusableView? = nil
		if kind == UICollectionElementKindSectionHeader {
			let reusableHeaderView: HeroCollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: heroReuseViewIdentifier, forIndexPath: indexPath) as! HeroCollectionReusableView
			var title: String?
			var image: UIImage?
			if indexPath.section == 0 {
				title = "Strength"
				let imageURL = NSBundle.mainBundle().URLForResource("overviewicon_str", withExtension: "png")
				let imageData = NSData(contentsOfURL: imageURL!)	
				image = UIImage(data: imageData!)!
			}
			else if indexPath.section == 1 {
				title = "Agility"
				let imageURL = NSBundle.mainBundle().URLForResource("overviewicon_agi", withExtension: "png")
				let imageData = NSData(contentsOfURL: imageURL!)
				image = UIImage(data: imageData!)!
			} else if indexPath.section == 3{
				title = "Intelligence"
				let imageURL = NSBundle.mainBundle().URLForResource("overviewicon_int", withExtension: "png")
				let imageData = NSData(contentsOfURL: imageURL!)
				image = UIImage(data: imageData!)!
			}
			
			reusableHeaderView.label.text = title
			reusableHeaderView.imageView.image = image
			reusableView = reusableHeaderView
		}
		if kind == UICollectionElementKindSectionFooter {
			let reusableFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footer", forIndexPath: indexPath) 
			reusableView = reusableFooterView
		}
		return reusableView!
		
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if resultDelegate?.searchHeroSelected != nil {
			resultDelegate?.searchHeroSelected!()
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
		let tempStrengs = (self.strengthHeros as NSArray).filteredArrayUsingPredicate(predicate)
		filteredStrengthHeros = NSArray(array: tempStrengs) as! [Hero]
		let tempAgilities = (self.agilityHeros as NSArray).filteredArrayUsingPredicate(predicate)
		filteredAgilityHeros = NSArray(array: tempAgilities) as! [Hero]
		let tempIntengences = (self.intelligenceHeros as NSArray).filteredArrayUsingPredicate(predicate)
		filteredIntelligenceHeros = NSArray(array: tempIntengences) as! [Hero]
		collectionView?.reloadData()
	}
	
	// MARK: returnButton 
	func returnButtonTouched(sender: AnyObject!) {
		self.dismissViewControllerAnimated(true, completion: {
			[weak delegate = self.resultDelegate!] in
			if delegate!.clearHeroSearchBarText != nil {
				delegate!.clearHeroSearchBarText!()
			}
			
		})
	}
}
