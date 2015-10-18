//
//  BattleDetailTableViewController.swift
//  DotaWatcher
//
//  Created by lunner on 10/8/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit
import CoreData

let NeedUpdatePlayerNamesNotification = "NeedUpdatePlayerNamesNotification"

class BattleDetailTableViewController: UITableViewController {
	
	let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
	var playerNames: [String: String]!
	var players: [PlayerBattleDetail] = [PlayerBattleDetail]() 
	var randiantPlayers = [PlayerBattleDetail]()
	var direPlayers = [PlayerBattleDetail]()
	let battleCellReuseIdentifier = "BattleCellReuseIdentifier"
	var direHides = [true, true, true, true, true]
	var randiantHides = [true, true, true, true, true]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		// Register NIB
		let nib = UINib(nibName: "BattleDetailTableViewCell", bundle: nil)
		
		self.tableView.registerNib(nib, forCellReuseIdentifier: battleCellReuseIdentifier)
		self.tableView.rowHeight = UITableViewAutomaticDimension
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatePlayerNames:", name: NeedUpdatePlayerNamesNotification, object: nil)
		
		self.parsePlayerNames()
		self.separatePlayersAsDiresAndRadiants()
		
    }
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.battleCellReuseIdentifier, forIndexPath: indexPath) as! BattleDetailTableViewCell

        // Configure the cell...
		cell.selectionStyle = UITableViewCellSelectionStyle.None
		self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		//let cell = tableView.cellForRowAtIndexPath(indexPath)
		print("heightForRowAtIndexPath")
		var isHide = false
		if indexPath.section == 0 {
			isHide = randiantHides[indexPath.row]
		} else {
			isHide = direHides[indexPath.row]
		}
		if isHide {
			return 60
		} else {
			return 180
		}
	}
	
	override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 190.0
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Radiant" 
		} else {
			return "Dire"
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)

		
		//let cell = tableView.cellForRowAtIndexPath(indexPath) as! BattleDetailTableViewCell
		
		//The stack view automatically updates its layout whenever views are added, removed or inserted into the arrangedSubviews array, or whenever one of the arranged subviews’s hidden property changes.
		

		//UIView.animateWithDuration(0.5, animations: {
			//cell.detailView.hidden = !cell.detailView.hidden
		//})
		if indexPath.section == 0 {
			randiantHides[indexPath.row] = !randiantHides[indexPath.row]
		} else {
			direHides[indexPath.row] = !direHides[indexPath.row]
		}
		self.tableView.reloadData()


		
	}
	    
    /*
 	//Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	func dismissSelf() {
		//dismissViewControllerAnimated(true, completion: nil)
		self.navigationController?.popViewControllerAnimated(true)
	}
	func shareBattleDetail() {
		
	}
	// MARK: Support funcs
	
	func updatePlayerNames(notification: NSNotification) {
		self.playerNames = notification.object as! [String: String]
		
		self.parsePlayerNames()
		self.separatePlayersAsDiresAndRadiants()

		self.tableView.reloadData()
	}
	
	func getHero(heroID: Int) -> Hero? {
		
		let fetchRequest = NSFetchRequest(entityName: "Hero")
		let predicate = NSPredicate(format: "hero_id == %@", NSNumber(integer: heroID))
		//let predicate = NSPredicate(format: "hero_id == %@", heroID)
		fetchRequest.predicate = predicate

		do {
			let result = try coreDataStack.mainContext.executeFetchRequest(fetchRequest) as! [Hero]
			if result.isEmpty {
				return nil
			}
			return result[0]
			
		} catch {
			print("\(error)")
		}
		return nil
		
	}
	
	func getItemImage(itemID: Int) -> UIImage? {
		if itemID == 0 {
			return nil
		}
		let fetchRequest = NSFetchRequest(entityName: "Item")
		let predicate = NSPredicate(format: "id == %@", NSNumber(integer: itemID))
		fetchRequest.predicate = predicate
		
		do {
			let result = try coreDataStack.mainContext.executeFetchRequest(fetchRequest) as! [Item]
			if result.isEmpty {
				return nil
			}
			let imageData = result[0].image.image
			return UIImage(data:imageData)!
			
		} catch {
			print("\(error)")
		}
		return nil
		
	}
	
	func configureCell(cell: BattleDetailTableViewCell, indexPath: NSIndexPath) {
		print("row: \(indexPath.row)")
		var player: PlayerBattleDetail
		if indexPath.section == 0 {
			player = self.randiantPlayers[indexPath.row]
		} else {
			player = self.direPlayers[indexPath.row]
		}
		if let hero = getHero(player.heroID) {
			cell.heroImageView.image = UIImage(data: hero.smallImage.image)
			cell.heroNameLabel.text = hero.localized_name
		} else {
			cell.heroImageView.image = nil
			cell.heroNameLabel.text = nil
		}
		

		// MARK: not always have six items
	
		for i in 0...5 {
			print("\(player.items.count): \(i)")
			cell.itemImageViews[i].image = getItemImage(player.items[i])
			cell.itemImageViews[i].hidden = false
			if cell.itemImageViews[i].image == nil {
				cell.itemImageViews[i].hidden = true
			}
		}
		

		cell.lastHitsLabel.text = player.lastHits.description
		cell.goldPerMinLabel.text = player.goldPerMin.description
		cell.goldSpendLabel.text = player.goldSpent.description
		cell.heroDamageLabel.text = player.heroDamage.description
		cell.towerDamageLabel.text = player.towerDamage.description
		cell.goldRemianLabel.text = player.gold.description
		cell.deniesLabel.text = player.denies.description
		cell.xpPerMinLabel.text = player.xpPerMin.description
		cell.killsLabel.text = player.kills.description
		cell.deathsLabel.text = player.deaths.description
		cell.assistsLabel.text = player.assists.description
		
		if player.name != nil {
			cell.nameLabel.text = player.name
		} else if currentRequestAccountID != nil {
			let accountID = Int(currentRequestAccountID!)
			if  accountID == player.accountID {
				cell.nameLabel.text = currentRequestPlayerName
			} else {
				cell.nameLabel.text = player.accountID.description
			}
		} else {
			cell.nameLabel.text = player.accountID.description
		}
		
		if indexPath.section == 0 {
			cell.detailView.hidden = randiantHides[indexPath.row]
		} else {
			cell.detailView.hidden = direHides[indexPath.row]
		}
		
		
	}
	
	func parsePlayerNames() {
		if self.playerNames == nil {
			return
		}
		for player in players {
			player.name = playerNames[LUUtils.convertTo64Bit(player.accountID).description]
		}
	}
	
	func separatePlayersAsDiresAndRadiants() {
		self.direPlayers.removeAll()
		self.randiantPlayers.removeAll()
		for player in self.players {
			if player.playerSlot.testBit(7) {
				self.direPlayers.append(player)
			} else {
				self.randiantPlayers.append(player)
			}
		}
		
		self.direPlayers.sortInPlace({
			(first, second) in
			let fposition: UInt8 = 0b00000111 | first.playerSlot
			let sposition: UInt8 = 0b00000111 | second.playerSlot
			return fposition < sposition
		})
		
		self.randiantPlayers.sortInPlace({
			(first, second) in
			let fposition: UInt8 = 0b00000111 | first.playerSlot
			let sposition: UInt8 = 0b00000111 | second.playerSlot
			return fposition < sposition
		})
	}

}
