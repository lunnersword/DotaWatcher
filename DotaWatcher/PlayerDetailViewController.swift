//
//  PlayerDetailViewController.swift
//  DotaWatcher
//
//  Created by lunner on 10/8/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit
import CoreData
import Foundation

let PlayerDetailNeedUpdateNotification = "PlayerDetailNeedUpdateNotification"
let PresentErrorTextViewNotification = "PresentErrorTextViewNotification"
let NeedInsertPlayerIntoCoreDataNotification = "NeedInsertPlayerIntoCoreDataNotification"
let NeedDisplayAccessNotPermittedInPlayerDetailNotification = "NeedDisplayAccessNotPermittedInPlayerDetailNotification"

let NeedUpdateAvatorMediumNotification = "NeedUpdateAvatorMediumNotification"
let NeedUpdateAvatorFullNotification = "NeedUpdateAvatorFullNotification"

class PlayerDetailViewController: UIViewController {
	@IBOutlet weak var mediumAvatar: UIImageView!
	@IBOutlet weak var mediumView: UIView!
	@IBOutlet weak var fullView: UIView!
	@IBOutlet weak var steamID: UILabel!
	@IBOutlet weak var personalstate: UILabel!
	@IBOutlet weak var lastLogOff: UILabel!
	@IBOutlet weak var fullAvatar: UIImageView!
	@IBOutlet weak var realname: UILabel!
	@IBOutlet weak var createTime: UILabel!
	@IBOutlet weak var profileState: UILabel!	
	@IBOutlet weak var profileURL: UILabel!	
	@IBOutlet weak var country: UILabel!	
	@IBOutlet weak var state: UILabel!
	@IBOutlet weak var city: UILabel!	
	@IBOutlet weak var friendListButton: UIButton!
	@IBOutlet weak var matchHistoryButton: UIButton!
	
	@IBOutlet weak var playerNameLabel: UILabel!
	var steamIDForSearch: String!
	var loadIndicator: UIActivityIndicatorView?
	var fullIndicator: UIActivityIndicatorView?
	var mediumIndicator: UIActivityIndicatorView?
	//var playerDict: NSDictionary!
	
	
	
	let dotaApi = (UIApplication.sharedApplication().delegate as! AppDelegate).dotaApi
	let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// asynchronize load the images
		let center = NSNotificationCenter.defaultCenter()
		center.addObserver(self, selector: "playerDetailNeedUpdate:", name: PlayerDetailNeedUpdateNotification, object: nil)
		center.addObserver(self, selector: "presentErrorTextView:", name: PresentErrorTextViewNotification, object: nil)
		center.addObserver(self, selector: "needInsertPlayerIntoCoreData:", name: NeedInsertPlayerIntoCoreDataNotification, object: nil)
		center.addObserver(self, selector: "needDisplayAccessNotPermitted:", name: NeedDisplayAccessNotPermittedInPlayerDetailNotification, object: nil)
		
		center.addObserver(self, selector: "needUpdateAvatorFull:", name: NeedUpdateAvatorFullNotification, object: nil)
		
		center.addObserver(self, selector: "needUpdateAvatorMedium:", name: NeedUpdateAvatorMediumNotification, object: nil)
		
		loadPlayerDetail()
				
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
	
	func dismissSelf() {
		dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func share() {
		
	}
	
	func favorite() {
		
	}
	
	
	@IBAction func friendListButtonTouched(sender: AnyObject) {
		
	}
	@IBAction func matchHistoryButtonTouched(sender: AnyObject) {
		let dotaID = LUUtils.convertTo32Bit(Int64(steamID.text!)!)
		presentMatchHistoryTableView(dotaID.description)
		
	}
	
	func presentMatchHistoryTableView(accountID: String) {
		let matchHistoryTableViewCTL = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MatchHistoryTableViewController") as! MatchHistoryTableViewController
		matchHistoryTableViewCTL.accountID = accountID
		let leftImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("back32", withExtension: "png")!)!)
		matchHistoryTableViewCTL.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .Plain, target: matchHistoryTableViewCTL, action: "dismissSelf")
		
		let rightImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("share32", withExtension: "png")!)!)
		matchHistoryTableViewCTL.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: matchHistoryTableViewCTL, action: "shareMatchHistory")
		matchHistoryTableViewCTL.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
		matchHistoryTableViewCTL.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
		//matchHistoryTableViewCTL.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
		showViewController(matchHistoryTableViewCTL, sender: self)
	}
	
	// MARK: support funcs
	
	func loadPlayerDetail() {
		//let idStr = dotaIDInputField.text
		for view in self.view.subviews {
			view.hidden = true
		}
		loadIndicator = UIActivityIndicatorView(frame: self.view.bounds)
		loadIndicator!.activityIndicatorViewStyle = .WhiteLarge
		self.view.addSubview(loadIndicator!)
		self.view.bringSubviewToFront(loadIndicator!)
		loadIndicator!.startAnimating()
		
		
		var steamID: Int64 = 0
		
		if let id: Int = Int(steamIDForSearch) {	
			steamID = LUUtils.convertTo64Bit(id)
			currentRequestSteamID = steamID
			currentRequestAccountID = id
		}
		else if let id: Int64 = Int64(steamIDForSearch) {
			steamID = id
		} else {
			// the id input is invalid
			// TODO: present the input invalid hint view
			loadIndicator!.stopAnimating()
			let label = UILabel(frame: loadIndicator!.frame)
			label.text = "Invalid ID"
			label.textColor = UIColor(red: 190/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
			label.backgroundColor = UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
			label.textAlignment = NSTextAlignment.Center
			self.view.addSubview(label)
			loadIndicator!.removeFromSuperview()

			return
		}
		// TODO: here should sync not async
		dotaApi.getPlayerSummariesAsync(steamID.description, completionHandler: {
			
			(response, data, error) in
			dispatch_sync(dispatch_get_main_queue(), {
				// MARK: test whether still in the PlayerDetailViewController if not return
				// MARK: still have problems because [unowned self] captured self, if you dismiss this controller crash!
				// MARK: instead post a notivacatifion, 
//				if !self.isKindOfClass(PlayerDetailViewController.self) {
//					return
//				}
				if error != nil {
					// request failed, 
					//				let alert = UIAlertController(title: error!.domain, message: error!.userInfo.description, preferredStyle: .Alert)	
					//				let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
					//				alert.addAction(OKAction)
					//				self.presentViewController(alert, animated: true, completion: nil)
					NSNotificationCenter.defaultCenter().postNotificationName(PresentErrorTextViewNotification, object: error)
					return
					
				}
				
				let arr = RequestResult.dataToDictionary(data)!["players"] as! NSArray
				let player = arr[0] as! NSDictionary
				// first search in the core data, whether the id exist, if not update the core data.
				//			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
				//				[unowned self] in
				let fetchRequest = NSFetchRequest(entityName: "Player")
				//fetchRequest.resultType = .CountResultType
				let playerPredicate: NSPredicate = NSPredicate(format: "dotaID == %@", Int(LUUtils.convertTo32Bit(steamID)).description)
				fetchRequest.predicate = playerPredicate
				var error: NSError?
				let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
				let count = coreDataStack.mainContext.countForFetchRequest(fetchRequest, error: &error) 
				if count == NSNotFound {
					print("Could not fetch \(error), \(error!.userInfo)")
				} else if count <= 0 {
					//insertPlayerToCoreData(player)
					print("post need insert into coredata notification")
					NSNotificationCenter.defaultCenter().postNotificationName(NeedInsertPlayerIntoCoreDataNotification, object: player)
				}
				
				// check whether the player is dispose profile as public
				if let visibilityState = (player["communityvisibilitystate"] as? Int) {
					if visibilityState < 3 {
						// the profile access setting is private or friends only.
						// TODO: present view tell that the profile is not public
						NSNotificationCenter.defaultCenter().postNotificationName(NeedDisplayAccessNotPermittedInPlayerDetailNotification, object: nil)
						
						return
					}
				}
				
			NSNotificationCenter.defaultCenter().postNotificationName(PlayerDetailNeedUpdateNotification, object: player)
				

			})
			
		})

	}
	func needDisplayAccessNotPermitted(notification: NSNotification) {
		if loadIndicator == nil {
			return
		}
		loadIndicator!.stopAnimating()
		let label = UILabel(frame: loadIndicator!.frame)
		label.text = "The player private is private"
		label.textColor = UIColor(red: 190/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
		label.backgroundColor = UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
		label.textAlignment = NSTextAlignment.Center
		self.view.addSubview(label)
		loadIndicator!.removeFromSuperview()
	}
	func needInsertPlayerIntoCoreData(notification: NSNotification) {
		let player = notification.object as! NSDictionary
		insertPlayerToCoreData(player)
	}
	
	func playerDetailNeedUpdate(notification: NSNotification) {
		if loadIndicator == nil {
			return
		}
		let player = notification.object as! NSDictionary
		self.setup(player)
		loadIndicator!.stopAnimating()
		loadIndicator!.removeFromSuperview()
	}
	func presentErrorTextView(notification: NSNotification) {
		if loadIndicator == nil {
			return
		}
		
		let error = notification.object as! NSError
		
		loadIndicator?.stopAnimating()
		let textView = UITextView(frame: loadIndicator!.frame)
		textView.text = "\(error.domain)" + "\n" + "\(error.userInfo.description)"
		textView.backgroundColor =  UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
		textView.textColor = UIColor(red: 190/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
		self.view.addSubview(textView)
		
		loadIndicator?.removeFromSuperview()
	}
	func insertPlayerToCoreData(playerDict: NSDictionary) {
		let steamID = Int64(playerDict["steamid"] as! String)
		let dotaID = LUUtils.convertTo32Bit(steamID!)
		let avatarURL = playerDict["avatar"] as! String //NSURL(string: playerDict["avatar"] as! String)
		
		
		let playerEntity = NSEntityDescription.entityForName("Player", inManagedObjectContext: coreDataStack.mainContext)
		let playerAvatarEntity = NSEntityDescription.entityForName("PlayerAvatar", inManagedObjectContext: coreDataStack.mainContext)
		
		Request.queuedGet(avatarURL, params: nil, completionHandler: {
			(response: NSURLResponse?, data: NSData?, error: NSError?) in
			//				result = RequestResult()
			//				result!.error = error
			//				let resp = response as! NSHTTPURLResponse
			//				result!.statusCode = resp.statusCode
			//				result!.resultData = data
			//let resp = response as! NSHTTPURLResponse
			//if resp.statusCode == 200

			dispatch_async(dispatch_get_main_queue(), {
//				if !self.isKindOfClass(PlayerDetailViewController.self) {
//					return
//				}
				if error == nil {
					// success
					let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
					let avatarData = data
					let player = Player(entity: playerEntity!, insertIntoManagedObjectContext: coreDataStack.mainContext)
					player.name = playerDict["personaname"] as? String
					player.dotaID = String(dotaID)
					let date = NSDate()
					
					player.time = NSNumber(double: date.timeIntervalSince1970)
					let playerAvatar = PlayerAvatar(entity: playerAvatarEntity!, insertIntoManagedObjectContext: coreDataStack.mainContext)
					playerAvatar.image = avatarData
					
					player.avatar = playerAvatar
					
					//save context
					print("save context")
					coreDataStack.saveContext(coreDataStack.mainContext)
					
				} else {
					// TODO: load image failed, should I put a placehold image instead?
				}
			})
		})
		
	}

	func setup(playerDict: NSDictionary) {
		for view in self.view.subviews {
			view.hidden = false
		}
		mediumIndicator = UIActivityIndicatorView(frame: mediumAvatar.frame)
		mediumIndicator!.activityIndicatorViewStyle = .White
		self.mediumView.addSubview(mediumIndicator!)
		self.mediumView.bringSubviewToFront(mediumIndicator!)
		mediumIndicator!.startAnimating()
		
		loadImage(playerDict["avatarmedium"] as! String, isFull: false)
		
		let fullAvatarActivityIndicator = UIActivityIndicatorView(frame: fullAvatar.frame)
		fullAvatarActivityIndicator.activityIndicatorViewStyle = .WhiteLarge
		self.fullView.addSubview(fullAvatarActivityIndicator)
		self.fullView.bringSubviewToFront(fullAvatarActivityIndicator)
		fullAvatarActivityIndicator.startAnimating()
		loadImage(playerDict["avatarfull"] as! String, isFull: true)
		self.steamID.text = playerDict["steamid"] as? String
		switch playerDict["personastate"] as! Int {
		case 0:
			self.personalstate.text = "Offline"
		case 1:
			self.personalstate.text = "Online"
		case 2:
			self.personalstate.text = "Busy"
		case 3:
			self.personalstate.text = "Away"
		case 4:
			self.personalstate.text = "Snooze"
		case 5:
			self.personalstate.text = "Looking to trade"
		case 6:
			self.personalstate.text = "Looking to play"
		default:
			self.personalstate.text = "Unknow"
		}
		self.playerNameLabel.text = playerDict["personaname"] as? String
		currentRequestPlayerName = self.playerNameLabel.text
		
		lastLogOff.text = parseTime(playerDict["lastlogoff"] as! Double)
		if let realName = playerDict["realname"] as? String {
			self.realname.text = realName
		} else {
			self.realname.text = "Unknow"
		}
		if let createtime = playerDict["timecreated"] as? Double {
			self.createTime.text = parseTime(createtime)
		} else {
			self.createTime.text = "Unknow"
		}
		if playerDict["profilestate"] as! Int == 1 {
			self.profileState.text = "Configured"
		} else {
			self.profileState.text = "Unconfigured"
		}
		self.profileURL.text = playerDict["profileurl"] as? String
		if let countryCode = playerDict["loccountrycode"] as? String  {
			// TODO: Now simplye display the country code, need to paser to country name
			self.country.text = countryCode
		} else {
			self.country.text = "Unknow"
		}
		
		if let stateCode = playerDict["locstatecode"] as? String {
			self.state.text = stateCode
		} else {
			self.state.text = "Unknow"
		}
		if let cityCode = playerDict["loccityid"] as? String {
			self.city.text = cityCode
		} else {
			self.city.text = "Unknow"
		}

	}
	
	func needUpdateAvatorMedium(notification: NSNotification) {
		if mediumIndicator == nil {
			return
		}
		let data = notification.object as! NSData
		mediumAvatar.image = UIImage(data: data)
		mediumIndicator?.stopAnimating()
		mediumIndicator?.removeFromSuperview()
	}
	
	func needUpdateAvatorFull(notification: NSNotification) {
		if fullIndicator == nil {
			return
		}
		let data = notification.object as! NSData
		fullAvatar.image = UIImage(data: data)
		fullIndicator!.stopAnimating()
		//fullIndicator!.superview?.bringSubviewToFront(imageView)
		fullIndicator!.removeFromSuperview()

	}
	
	func loadImage(url: String, isFull: Bool) {
		Request.queuedGet(url, params: nil, completionHandler: {
			(response: NSURLResponse?, data: NSData?, error: NSError?) in
			if !self.isKindOfClass(PlayerDetailViewController.self) {
				return
			}
			if error == nil {
				// success
				if isFull {
					NSNotificationCenter.defaultCenter().postNotificationName(NeedUpdateAvatorFullNotification, object: data)
				} else {
					NSNotificationCenter.defaultCenter().postNotificationName(NeedUpdateAvatorMediumNotification, object: data)
				}
				
			} else {
				// TODO: load image failed, should I put a placehold image instead?
			}
		})

	}
	
	func parseTime(interval: NSTimeInterval) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		let date = NSDate(timeIntervalSince1970: interval)
		return dateFormatter.stringFromDate(date)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
    

}
