//
//  HerosCollectionViewController.swift
//  DotaWatcher
//
//  Created by lunner on 9/20/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit



protocol HeroCollectionViewDelegate {
	 var strengthHeros: [Hero]! { get set }
	 var agilityHeros: [Hero]! { get set }
	 var intelligenceHeros: [Hero]! { get set }
	
	 var filteredStrengthHeros: [Hero]! { get set }
	 var filteredAgilityHeros: [Hero]! { get set }
	 var filteredIntelligenceHeros: [Hero]! { get set }
	func heroSelected(indexPath: NSIndexPath)

}

class HeroCollectionViewController: UICollectionViewController {
	var heroDelegate: HeroCollectionViewDelegate!
	
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
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		let nib = UINib(nibName: "HeroCollectionViewCell", bundle: nil)
		collectionView?.registerNib(nib, forCellWithReuseIdentifier: heroReuseIdentifier)
		let headNib = UINib(nibName: "HeroCollectionReusableView", bundle: nil)
		collectionView?.registerNib(headNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: heroReuseViewIdentifier)
		collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
		collectionView!.backgroundColor = UIColor.blackColor()

        // Do any additional setup after loading the view.
//		let flowLayout = CollectionViewFlowLayout(itemSize: CGSizeMake(59, 33), headHeight: 33)
//		flowLayout.invalidateLayout()
//		collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
//		//collectionView?.setCollectionViewLayout(flowLayout, animated: false)
//		collectionView?.reloadData()
		//self.collectionView?.delegate = self;
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
		if !heroDelegate.filteredAgilityHeros.isEmpty {
			sectionCount += 1
		} 
		if !heroDelegate.filteredStrengthHeros.isEmpty {
			sectionCount += 1
		}
		if !heroDelegate.filteredIntelligenceHeros.isEmpty {
			sectionCount += 1
		}
		return sectionCount

    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items

		switch section {
		case 0:
			return heroDelegate.filteredStrengthHeros.count
		case 1:
			return heroDelegate.filteredAgilityHeros.count
		case 2:
			return heroDelegate.filteredIntelligenceHeros.count
		default:
			return 0
		}
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(heroReuseIdentifier, forIndexPath: indexPath) as! HeroCollectionViewCell
    
        // Configure the cell
		
		var smallImageData: NSData?
		switch indexPath.section {
		case 0:
			smallImageData = (heroDelegate.filteredStrengthHeros[indexPath.row].smallImage as HeroSmallImage).image
		case 1:
			smallImageData = (heroDelegate.filteredAgilityHeros[indexPath.row].smallImage as HeroSmallImage).image
		case 2:
			smallImageData = (heroDelegate.filteredIntelligenceHeros[indexPath.row].smallImage as HeroSmallImage).image
		default:
			break
		}
		
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
			} else if indexPath.section == 2 {
				title = "Intelligence"
				let imageURL = NSBundle.mainBundle().URLForResource("overviewicon_int", withExtension: "png")
				let imageData = NSData(contentsOfURL: imageURL!)
				image = UIImage(data: imageData!)!
			}
			
			reusableHeaderView.label.text = title
			reusableHeaderView.imageView.image = image
			reusableHeaderView.backgroundColor = UIColor.blackColor()
			reusableView = reusableHeaderView
		}
		if kind == UICollectionElementKindSectionFooter {
			let reusableFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footer", forIndexPath: indexPath) 
			reusableView = reusableFooterView
		}
		return reusableView!
		
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if heroDelegate?.heroSelected != nil {
			heroDelegate?.heroSelected(indexPath)
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
	
//	override func scrollViewDidScroll(scrollView: UIScrollView) {
//		super.scrollViewDidScroll(scrollView)
//		print("HeroCollection")
//		if(scrollView.isKindOfClass(UIScrollView.self)){
//			print("UIScrollView")
//		}
//	}

}
