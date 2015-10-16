//
//  MatchHistoryTableViewController.swift
//  DotaWatcher
//
//  Created by lunner on 10/8/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit
import CoreData

enum MatchHistoryNotifications: String {
	case PresentErrorTextView = "MatchHistoryPresentErrorTextView"
	case UpdateTableView = "MatchHistoryUpdateTableView"
	case DisplayAccessNotPermitted = "MatchHistoryDisplayAccessNotPermitted"
}


class MatchHistoryTableViewController: UITableViewController {
	let dotaApi = (UIApplication.sharedApplication().delegate as! AppDelegate).dotaApi
	let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
	
	var accountID: String!
	var matches = [MatchItem]()
	
	var loadIndicator: UIActivityIndicatorView?
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		// register cell
		let nib = UINib(nibName: "MatchTableViewCell", bundle: nil)
		self.tableView.registerNib(nib, forCellReuseIdentifier: "MatchTableViewCellReusableIdentifier")
		
		let center = NSNotificationCenter.defaultCenter()
		center.addObserver(self, selector: "presentErrorTextView:", name: MatchHistoryNotifications.PresentErrorTextView.rawValue, object: nil)
		center.addObserver(self, selector: "updateMatchHistoryTableview:", name: MatchHistoryNotifications.UpdateTableView.rawValue, object: nil)
		center.addObserver(self, selector: "displayAccessNotPermitted", name: MatchHistoryNotifications.DisplayAccessNotPermitted.rawValue, object: nil)
		
		loadMatchHistory()
    }
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	func presentErrorTextView(notification: NSNotification) {
		if loadIndicator == nil {
			return
		}
		let error = notification.object as! NSError
		
		loadIndicator!.stopAnimating()
		let textView = UITextView(frame: loadIndicator!.frame)
		textView.text = "\(error.domain)" + "\n" + "\(error.userInfo.description)"
		textView.backgroundColor =  UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
		textView.textColor = UIColor(red: 190/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
		self.view.addSubview(textView)
		loadIndicator!.removeFromSuperview()
	}
	
	func updateMatchHistoryTableview(notification: NSNotification) {
		if loadIndicator == nil {
			return
		}
		let dict = notification.object as! NSDictionary
		let matches = dict["matches"] as! NSArray
		self.matches.appendContentsOf(self.parseMathesDictToMatchItemArray(matches))
		self.tableView.reloadData()
		for view in self.view.subviews {
			view.hidden = false
		}
		loadIndicator!.stopAnimating()
		self.view.bringSubviewToFront(self.tableView)
		loadIndicator!.removeFromSuperview()
	}
	func displayAccessNotPermitted(notification: NSNotification) {
		if loadIndicator == nil {
			return
		}
		loadIndicator!.stopAnimating()
		let label = UILabel(frame: loadIndicator!.frame)
		label.text = "Cannot get match history for a user that hasn't allow it."
		label.textColor = UIColor(red: 190/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
		label.backgroundColor = UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
		label.textAlignment = NSTextAlignment.Center
		self.view.addSubview(label)
		loadIndicator!.removeFromSuperview()
	}
	func loadMatchHistory() {
		for view in self.view.subviews {
			view.hidden = true
		}
		// show an loading indicator
		loadIndicator = UIActivityIndicatorView(frame: self.tableView.frame)
		loadIndicator!.activityIndicatorViewStyle = .WhiteLarge
		self.view.addSubview(loadIndicator!)
		self.view.bringSubviewToFront(loadIndicator!)
		loadIndicator!.startAnimating()

		dotaApi.getMatchHistoryAsync(accountID, completionHandler: {
			(response, data, error) in
			
			dispatch_async(dispatch_get_main_queue(), {
				if error != nil {
					// request failed,
					print("Error: \(error)")
					NSNotificationCenter.defaultCenter().postNotificationName(MatchHistoryNotifications.PresentErrorTextView.rawValue, object: error)
					return
					
				}
				if let dict = RequestResult.dataToDictionary(data) {
					if dict["status"] as! Int == 1 {
						NSNotificationCenter.defaultCenter().postNotificationName(MatchHistoryNotifications.UpdateTableView.rawValue, object: dict)
						
					} else {
						// Cannot get match history for a user that hasn't allow it. 
						NSNotificationCenter.defaultCenter().postNotificationName(MatchHistoryNotifications.DisplayAccessNotPermitted.rawValue, object: nil)
						return
						
					}
					
				}

			})
		})
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matches.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchTableViewCellReusableIdentifier", forIndexPath: indexPath) as! MatchTableViewCell

        // Configure the cell...
		let match = matches[indexPath.row]
		
		configureCell(cell, match: match)
        return cell
    }
	
	override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80.0
	}   
 
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		presentMatchDetailViewController(indexPath)
	}
	func configureCell(cell: MatchTableViewCell, match: MatchItem) {
		let direColor = UIColor(red: 127/255.0, green: 75/255.0, blue: 67/255.0, alpha: 1.0)
		let radiantColor = UIColor(red: 118/255.0, green: 191/255.0, blue: 50/255.0, alpha: 1.0)
		if	match.isDire {
			cell.campLabel.text = "Dire"
			cell.campLabel.backgroundColor = direColor
		} else {
			cell.campLabel.text = "Radiant"
			cell.campLabel.backgroundColor = radiantColor
		}
		cell.imageView?.image = match.image
		let startDate = NSDate(timeIntervalSince1970: match.startTime)
		let dayFormatter = NSDateFormatter()
		dayFormatter.dateFormat = "yyyy-MM-dd"
		let timeFormatter = NSDateFormatter()
		timeFormatter.dateFormat = "HH:mm"

		cell.dayLabel.text = dayFormatter.stringFromDate(startDate)
		cell.timeLabel.text = timeFormatter.stringFromDate(startDate)
		switch match.lobbyType {
		case LobbyType.Invalid:
			cell.lobbyTypeLabel.text = "Invalid"
		case .PublicMatchMaking:
			cell.lobbyTypeLabel.text = "Public Matchmaking"
		case .Practise:
			cell.lobbyTypeLabel.text = "Practise"
		case .Tournament:
			cell.lobbyTypeLabel.text = "Tournament"
		case .Tutorial:
			cell.lobbyTypeLabel.text = "Tutorial"
		case .Co_opWithBots:
			cell.lobbyTypeLabel.text = "Co-op with bots"
		case .TeamMatch:
			cell.lobbyTypeLabel.text = "Team match"
		case .SoloQueue:
			cell.lobbyTypeLabel.text = "Solo Queue"
		case .RankedMatchMaking:
			cell.lobbyTypeLabel.text = "Ranked Matchmaking"
		case .OnevVOneSoloMid:
			cell.lobbyTypeLabel.text = "1v1 Solo Mid"
		}
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
		// Dismisses the view controller that was presented modally by the view controller. So here all the navigation controllers will be dismiss. 
		//dismissViewControllerAnimated(true, completion: nil)
		// Instead use 
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func shareMatchHistory() {
		print("share match history")
	}
	
	func presentMatchDetailViewController(indexPath: NSIndexPath) {
		let match = matches[indexPath.row]
		let matchDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MatchDetailViewController") as! MatchDetailViewController
		matchDetailViewController.matchID = match.matchID
		print("\(matchDetailViewController.matchID)")
		
		let leftImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("back32", withExtension: "png")!)!)
		matchDetailViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .Plain, target: matchDetailViewController, action: "dismissSelf")
		
		let rightImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("share32", withExtension: "png")!)!)
		matchDetailViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: matchDetailViewController, action: "shareMatchDetail")
		matchDetailViewController.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
		matchDetailViewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
		matchDetailViewController.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
		showViewController(matchDetailViewController, sender: self)
	}
	
	
	// MARK: Support funcs
	func parseMathesDictToMatchItemArray(matches: NSArray) -> [MatchItem] {
		var matchArray = [MatchItem]()
		for dictElement in matches {
			let dict = dictElement as! NSDictionary
			let players = dict["players"] as! NSArray
			var isDire: Bool = false
			var heroID: Int
			var heroImage: UIImage?
			
			let fetchRequest = NSFetchRequest(entityName: "Hero")
				


			for	playerElement in players {
				let player = playerElement as! NSDictionary
				if player["account_id"] as! Int == Int(self.accountID) {
					heroID = player["hero_id"] as! Int
					let playerSlot = UInt8(player["player_slot"] as! Int)

					isDire = playerSlot.testBit(Int(7))
					// MARK: NSNumber == Int
					//let predicate = NSPredicate(format: "hero_id == %@", heroID)
					let predicate = NSPredicate(format: "hero_id == %@", NSNumber(integer: heroID))
					fetchRequest.predicate = predicate
										
					do {
						let result = try coreDataStack.mainContext.executeFetchRequest(fetchRequest) as! [Hero]
						let imageData = result[0].smallImage.image
						heroImage = UIImage(data:imageData)
						
					} catch {
						print("\(error)")
					}
				}
			}
			
			
			let lobbyType = LobbyType(rawValue: dict["lobby_type"] as! Int)
			let startTime = dict["start_time"] as! NSTimeInterval
			let matchID = (dict["match_id"] as! Int).description
			let matchItem = MatchItem(startTime: startTime, lobbyType: lobbyType!, heroImage: heroImage, isDire: isDire, matchID: matchID)
			matchArray.append(matchItem)
			
		}
		return matchArray
	}

}
