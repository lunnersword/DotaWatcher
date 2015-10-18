//
//  RequestMainViewController.swift
//  DotaWatcher
//
//  Created by lunner on 10/8/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit
import CoreData

let playerTableCellIdentifier = "PlayerTableCellIdentifier"

var currentRequestAccountID: Int?
var currentRequestSteamID: Int64?
var currentRequestPlayerName: String?

class RequestMainViewController: UIViewController, NSFetchedResultsControllerDelegate {

	@IBOutlet weak var dotaIDInputField: UITextField!
	
	@IBOutlet weak var tableView: UITableView!
	
	let dotaApi = (UIApplication.sharedApplication().delegate as! AppDelegate).dotaApi
	let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
	
	var fetchedResultsController: NSFetchedResultsController!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		
		//register
		let nib = UINib(nibName: "PlayerTableViewCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: playerTableCellIdentifier)
		
		let fetchRequest = NSFetchRequest(entityName: "Player")
		let timeSort = NSSortDescriptor(key: "time", ascending: false)
		let nameSort = NSSortDescriptor(key: "name", ascending: true)
		let idSort = NSSortDescriptor(key: "dotaID", ascending: true)
		fetchRequest.sortDescriptors = [timeSort, nameSort, idSort]
		
		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		do {
			print(" per form  tetch")
			try fetchedResultsController.performFetch()
		} catch {
			print("Error: \(error)")
		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func requestButtonTouched(sender: AnyObject) {
				// TODO: present PlayerDetailViewCRL
		if self.dotaIDInputField.text == nil || self.dotaIDInputField.text == "" {
			return
		}
		let playerNavigationCRL = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RequestNavigationController")
		let playerDetailViewCRL = playerNavigationCRL.childViewControllers[0] as! PlayerDetailViewController
		playerDetailViewCRL.steamIDForSearch = dotaIDInputField.text 
		
		//setupViewControllerNavigationBarItem(playerDetailViewCRL, isShare: true)
		let leftImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("back32", withExtension: "png")!)!)
		playerDetailViewCRL.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .Plain, target: playerDetailViewCRL, action: "dismissSelf")
		
		
		let rightImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("share32", withExtension: "png")!)!)
		playerDetailViewCRL.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: playerDetailViewCRL, action: "share")
		
		playerDetailViewCRL.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
		playerDetailViewCRL.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()

		
		self.showViewController(playerNavigationCRL, sender: self)
		
	}
	func playerSelected(player: Player) {
		var steamID: Int64 = 0

		if let id: Int = Int(player.dotaID!) {
			steamID = LUUtils.convertTo64Bit(id)		
		}
				// TODO: present PlayerDetailViewCRL
		let playerNavigationCRL = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RequestNavigationController")
		let playerDetailViewCRL = playerNavigationCRL.childViewControllers[0] as! PlayerDetailViewController
		playerDetailViewCRL.steamIDForSearch = steamID.description 
//		setupViewControllerNavigationBarItem(playerDetailViewCRL, isShare: true)
		
		self.showViewController(playerNavigationCRL, sender: self)


	}
	
	// MARK: TableView
	func numberOfSectionsInTableView
		(tableView: UITableView) -> Int {
		return fetchedResultsController.sections!.count
	}
	
	func tableView(tableView: UITableView,
		titleForHeaderInSection section: Int) -> String? {
		return "Players I have searched:"
	}
	
	func tableView(tableView: UITableView,
		numberOfRowsInSection section: Int) -> Int {
			
			let sectionInfo = fetchedResultsController.sections![section]
			
			return sectionInfo.numberOfObjects
	}
	
	
	func tableView(tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath)
		-> UITableViewCell {
			
			//let resuseIdentifier = "teamCellReuseIdentifier"
			
			let cell =
			tableView.dequeueReusableCellWithIdentifier(
				playerTableCellIdentifier, forIndexPath: indexPath)
				as! PlayerTableViewCell
			
			configureCell(cell, indexPath: indexPath)
			
			return cell
	}
	
	func configureCell(cell: PlayerTableViewCell, indexPath: NSIndexPath) {
		let player =
		fetchedResultsController.objectAtIndexPath(indexPath)
			as! Player
		
		cell.dotaID.text = player.dotaID
		cell.name.text = player.name
		cell.profileImageView.image = UIImage(data: (player.avatar?.image)!)
	}
	
	
	func tableView(tableView: UITableView,
		didSelectRowAtIndexPath indexPath: NSIndexPath) {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
			
			let player =
			fetchedResultsController.objectAtIndexPath(indexPath)
				as! Player 
			let date = NSDate()
			player.time = NSNumber(double: date.timeIntervalSince1970)
			coreDataStack.saveContext(coreDataStack.mainContext)
			playerSelected(player)
			
	}
	
	func controllerWillChangeContent(controller:
		NSFetchedResultsController) {
			tableView.beginUpdates()
	}
	
	func controller(controller: NSFetchedResultsController,
		didChangeObject anObject: AnyObject,
		atIndexPath indexPath: NSIndexPath?,
		forChangeType type: NSFetchedResultsChangeType,
		newIndexPath: NSIndexPath?) {
			
			switch type {
			case .Insert:
				tableView.insertRowsAtIndexPaths([newIndexPath!],
					withRowAnimation: .Automatic)
			case .Delete:
				tableView.deleteRowsAtIndexPaths([indexPath!],
					withRowAnimation: .Automatic)
			case .Update:
				let cell = tableView.cellForRowAtIndexPath(indexPath!)
					as! PlayerTableViewCell
				configureCell(cell, indexPath: indexPath!)
			case .Move:
				tableView.deleteRowsAtIndexPaths([indexPath!],
					withRowAnimation: .Automatic)
				tableView.insertRowsAtIndexPaths([newIndexPath!],
					withRowAnimation: .Automatic)
			}
	}
	
	func controllerDidChangeContent(controller:
		NSFetchedResultsController) {
			tableView.endUpdates()
			//tableView.reloadData()
	}
	
	func controller(controller: NSFetchedResultsController,
		didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
		atIndex sectionIndex: Int,
		forChangeType type: NSFetchedResultsChangeType) {
			
			let indexSet = NSIndexSet(index: sectionIndex)
			
			switch type {
			case .Insert:
				tableView.insertSections(indexSet,
					withRowAnimation: .Automatic)
			case .Delete:
				tableView.deleteSections(indexSet,
					withRowAnimation: .Automatic)
			default :
				break
			}
	}
	


}
