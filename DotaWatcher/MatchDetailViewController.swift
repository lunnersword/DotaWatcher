//
//  MatchDetailViewController.swift
//  DotaWatcher
//
//  Created by lunner on 10/8/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit

enum MatchDetailNotifications: String {
	case PresentErrorTextView = "MatchDetailPresentErrorTextView"
	case UpdateMatchDetail = "MatchDetailUpdateMatchDetail"

}

class MatchDetailViewController: UIViewController {

	@IBOutlet weak var matchIDLabel: UILabel!
	
	@IBOutlet weak var startTimeLabel: UILabel!
	
	@IBOutlet weak var firstBloodTimeLabel: UILabel!
	
	@IBOutlet weak var durationLabel: UILabel!
	@IBOutlet weak var seasonLabel: UILabel!
	
	@IBOutlet weak var matchSeqNumLabel: UILabel!
	
	@IBOutlet weak var lobbyTypeLabel: UILabel!
	@IBOutlet weak var gameModeLabel: UILabel!
	

	@IBOutlet var radiantTowers: [UIImageView]!
	@IBOutlet var direTowers: [UIImageView]!
	
	@IBOutlet var radiantBarracks: [UILabel]!
	
	@IBOutlet var direBarracks: [UILabel]!
	
	@IBOutlet weak var scrollView: UIScrollView!

	
	var matchID: String!
	let dotaApi = (UIApplication.sharedApplication().delegate as! AppDelegate).dotaApi
	
	var players: NSArray!
	
	var loadIndicator: UIActivityIndicatorView?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let center = NSNotificationCenter.defaultCenter()
		center.addObserver(self, selector: "presentErrorTextView:", name: MatchDetailNotifications.PresentErrorTextView.rawValue, object: nil)
		center.addObserver(self, selector: "updateMatchDetail:", name: MatchDetailNotifications.UpdateMatchDetail.rawValue, object: nil)
		loadMatchDetail()
    }
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	func updateMatchDetail(notification: NSNotification) {
		if loadIndicator == nil {
			return
		}
		let dict = notification.object as! NSDictionary
		
		if let players = dict["players"] as? NSArray {
			self.players = players
		} else {
			
		}
		let matchID = dict["match_id"] as! Int
		let startTime = dict["start_time"] as! Double
		let firstBloodTime = dict["first_blood_time"] as! Double
		let duration = dict["duration"] as! Double
		
		self.matchIDLabel.text = matchID.description 
		self.startTimeLabel.text = LUUtils.getDateStringFromUnixTimeStamp(startTime)
		self.firstBloodTimeLabel.text = LUUtils.getClockStringFromUnixTimeStamp(startTime+firstBloodTime)
		self.durationLabel.text = LUUtils.getClockStringFromUnixTimeStamp(startTime + duration)
		
		if let session = dict["season"] as? String {
			self.seasonLabel.text = session
		} else {
			self.seasonLabel.text = "Unknow"
		}
		let seqnum = dict["match_seq_num"] as! Int

		self.matchSeqNumLabel.text = seqnum.description
		let lobbyType = LobbyType(rawValue: dict["lobby_type"] as! Int )!
		switch lobbyType {
		case LobbyType.Invalid:
			self.lobbyTypeLabel.text = "Invalid"
		case .PublicMatchMaking:
			self.lobbyTypeLabel.text = "Public Matchmaking"
		case .Practise:
			self.lobbyTypeLabel.text = "Practise"
		case .Tournament:
			self.lobbyTypeLabel.text = "Tournament"
		case .Tutorial:
			self.lobbyTypeLabel.text = "Tutorial"
		case .Co_opWithBots:
			self.lobbyTypeLabel.text = "Co-op with bots"
		case .TeamMatch:
			self.lobbyTypeLabel.text = "Team match"
		case .SoloQueue:
			self.lobbyTypeLabel.text = "Solo Queue"
		case .OnevVOneSoloMid:
			self.lobbyTypeLabel.text = "1v1 Solo Mid"
		case .RankedMatchMaking:
			self.lobbyTypeLabel.text = "Ranked MatchMaking"
		}
		let gameMode = GetMatchDetailsGameMode(rawValue: UInt32(dict["game_mode"] as! Int))
		switch gameMode! {
		case .None:
			self.gameModeLabel.text = "None"
		case .AllPick:
			self.gameModeLabel.text = "All Pick"
		case .CaptainsMode:
			self.gameModeLabel.text = "Captains Mode"
		case .RandomDraft:
			self.gameModeLabel.text = "Random Draft"
		case .SignleDraft:
			self.gameModeLabel.text = "Single Draft"
		case .AllRandom:
			self.gameModeLabel.text = "All Random"
		case .Intro:
			self.gameModeLabel.text = "Intro"
		case .Diretide:
			self.gameModeLabel.text = "Diretide"
		case .ReverseCaptainsMode:
			self.gameModeLabel.text = "Reverse Captain's Mode"
		case .TheGreeviling:
			self.gameModeLabel.text = "The Greeviling"
		case .Tutorial:
			self.gameModeLabel.text = "Tutorial"
		case .MidOnly:
			self.gameModeLabel.text = "Mid Only"
		case .LeastPlayed:
			self.gameModeLabel.text = "Least Played"
		case .NewPlayerPool:
			self.gameModeLabel.text = "New Player Pool"
		case .CompendiumMatchmaking:
			self.gameModeLabel.text = "Compendium Matchmaking"
		case .CaptainsDraft:
			self.gameModeLabel.text = "Captains Draft"
		}
		self.setTowerStatus(UInt16(dict["tower_status_radiant"] as! Int), direStatus: UInt16(dict["tower_status_dire"] as! Int))
		self.setBarrackStatus(UInt8(dict["barracks_status_radiant"] as! Int), direStatus: UInt8(dict["barracks_status_dire"] as! Int))
		self.scrollView.hidden = false
		loadIndicator!.stopAnimating()
		loadIndicator!.removeFromSuperview()
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

	func loadMatchDetail() {
		self.scrollView.hidden = true
		loadIndicator = UIActivityIndicatorView(frame: self.scrollView.bounds)
		loadIndicator!.activityIndicatorViewStyle = .WhiteLarge
		self.view.bringSubviewToFront(loadIndicator!)
		loadIndicator!.startAnimating()
		
		dotaApi.getMatchDetailsAsync(self.matchID, completionHandler: {
			(response, data, error) in
			dispatch_async(dispatch_get_main_queue(), {
				if error != nil {
					print("Error: \(error)")
					NSNotificationCenter.defaultCenter().postNotificationName(MatchDetailNotifications.PresentErrorTextView.rawValue, object: error)
					return
				}
				
				if let dict = RequestResult.dataToDictionary(data) {
				
					NSNotificationCenter.defaultCenter().postNotificationName(MatchDetailNotifications.UpdateMatchDetail.rawValue, object: dict)
				}
			})
		
		})
		
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

	@IBAction func matchDetailButtonTouched(sender: AnyObject) {
		if self.players != nil {
			let battleDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BattleDetailTableViewController") as! BattleDetailTableViewController
			battleDetailViewController.players = getPlayerBattleDetails(self.players)
			
			let leftImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("back32", withExtension: "png")!)!)
			battleDetailViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .Plain, target: battleDetailViewController, action: "dismissSelf")
			let rightImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("share32", withExtension: "png")!)!)
			battleDetailViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Plain, target: battleDetailViewController, action: "shareBattleDetail")
			battleDetailViewController.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
			battleDetailViewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
			battleDetailViewController.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
			showViewController(battleDetailViewController, sender: self)
		}
	}
	
	func dismissSelf() {
		//dismissViewControllerAnimated(true, completion: nil)
		self.navigationController?.popViewControllerAnimated(true)
	}
	func shareMatchDetail() {
		
	}
	// MARK: Support funcs
	
	func getPlayerBattleDetails(array: NSArray) -> [PlayerBattleDetail] {
		var players = [PlayerBattleDetail]()
		for element in array {
			let dict = element as! NSDictionary
			let player = PlayerBattleDetail()
			let accountid = dict["account_id"] as! Int
			player.accountID = accountid
			player.playerSlot = UInt8(dict["player_slot"] as! Int)
			player.heroID = dict["hero_id"] as! Int
			// now player.items is nil
			var items = [Int]()
			for i in 0...5 {
				let key = "item_" + "\(i)"
				print(key)
				
				items.append(dict[key] as! Int)
			}
			player.items = items
			player.kills = dict["kills"] as! Int
			player.deaths = dict["deaths"] as! Int
			player.assists = dict["assists"] as! Int
			player.gold = dict["gold"] as! Int
			player.lastHits = dict["last_hits"] as! Int
			player.denies = dict["denies"] as! Int
			player.goldPerMin = dict["gold_per_min"] as! Int
			player.xpPerMin = dict["xp_per_min"] as! Int
			player.goldSpent = dict["gold_spent"] as! Int
			player.heroDamage = dict["hero_damage"] as! Int
			player.towerDamage = dict["tower_damage"] as! Int
			player.heroHealing = dict["hero_healing"] as! Int
			player.level = dict["level"] as! Int
			let abilityUpgrades = dict["ability_upgrades"] as! NSArray
			var abilityUpgradeArray = [[String: Int]]()
			for element in abilityUpgrades {
				let abilityUpgrade = element as! NSDictionary
				var dict = [String: Int]()
				dict["ability"] = abilityUpgrade["ability"] as! Int
				dict["time"] = abilityUpgrade["time"] as! Int
				dict["level"] = abilityUpgrade["level"] as! Int
				abilityUpgradeArray.append(dict)
			}
			player.abilityUpgrades = abilityUpgradeArray	
			players.append(player)
			
			
		}
		return players
	}
	
	
	func setTowerStatus(radiantStatus: UInt16, direStatus: UInt16) {
		let radiantFullData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("towerWhite32", withExtension: "png")!)
		let radiantFullImage = UIImage(data: radiantFullData!)
		
		let radiantBrokenData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("brokenTowerWhite32", withExtension: "png")!)
		let radiantBrokenImage = UIImage(data: radiantBrokenData!)
		
		let direFullData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("tower32", withExtension: "png")!)
		let direFullImage = UIImage(data: direFullData!)
		
		let direBrokenData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("brokenTower32", withExtension: "png")!)
		let direBrokenImage = UIImage(data: direBrokenData!)
		
		for i in 0..<self.radiantTowers.count {
			if radiantStatus.testBit(i) {
				self.radiantTowers[i].image = radiantFullImage
			} else {
				self.radiantTowers[i].image = radiantBrokenImage
			}
		}
		
		for i in 0..<self.direTowers.count {
			if direStatus.testBit(i) {
				self.direTowers[i].image = direFullImage
			} else {
				self.direTowers[i].image = direBrokenImage
			}
		}
	}
	
	func setBarrackStatus(radiantStatus: UInt8, direStatus: UInt8) {
		for i in 0..<self.radiantBarracks.count {
			if radiantStatus.testBit(i) {
				self.radiantBarracks[i].text = "Intact"
			} else {
				self.radiantBarracks[i].text = "Broken"
			}
		}
		for i in 0..<self.direBarracks.count {
			if direStatus.testBit(i) {
				self.direBarracks[i].text = "Intact"
			} else {
				self.direBarracks[i].text = "Broken"
			}
		}
	}
}
