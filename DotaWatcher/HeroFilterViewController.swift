//
//  FilterViewController.swift
//  DotaWatcher
//
//  Created by lunner on 9/22/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit

protocol HeroFilterDelegate {
	func heroFilterChanged(attackType: HeroAttackType, roles: [HeroRole])
}

class HeroFilterViewController: UIViewController {
	var attackType: HeroAttackType = .All
	var roles: [HeroRole] = [HeroRole]()
	
	var delegate: HeroFilterDelegate?
	
	@IBOutlet weak var attributeButton: UIButton!
	@IBOutlet weak var alphabetButton: UIButton!
	@IBOutlet weak var meleeButton: UIButton!
	@IBOutlet weak var rangedButton: UIButton!
	@IBOutlet weak var initiatorButton: UIButton!
	@IBOutlet weak var carryButton: UIButton!
	@IBOutlet weak var nukerButton: UIButton!
	@IBOutlet weak var pusherButton: UIButton!
	@IBOutlet weak var supportButton: UIButton!
	@IBOutlet weak var escape: UIButton!
	@IBOutlet weak var disablerButton: UIButton!
	@IBOutlet weak var junglerButton: UIButton!
	@IBOutlet weak var durableButton: UIButton!
	@IBOutlet weak var laneSupportButton: UIButton!
	let redColor = UIColor(red: 134.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
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
	func roleButtonTouched(sender: UIButton, role: HeroRole) {
		if roles.contains(role) {
			roles.removeAtIndex(roles.indexOf(role)!)
			sender.setTitleColor(redColor, forState: .Normal)
			sender.backgroundColor = UIColor.whiteColor()
		} else {
			roles.append(role)
			sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
			sender.backgroundColor = redColor
		}
		delegate?.heroFilterChanged(attackType, roles: roles)
	}
	@IBAction func buttonTouched(sender: UIButton) {
		switch sender.tag {
		case 0:
			//attribute 
			break
		case 1:
			//alphabet
			break
		case 2:
			//melee
			if attackType == HeroAttackType.Melee {
				attackType = HeroAttackType.All
				sender.setTitleColor(redColor, forState: .Normal)
				sender.backgroundColor = UIColor.whiteColor()
			} else {
				attackType = HeroAttackType.Melee
				sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
				sender.backgroundColor = redColor
			}
			delegate?.heroFilterChanged(attackType, roles: roles)
		case 3:
			// ranged
			if attackType == HeroAttackType.Ranged {
				attackType = HeroAttackType.All
				sender.setTitleColor(redColor, forState: .Normal)
				sender.backgroundColor = UIColor.whiteColor()
			} else {
				attackType = HeroAttackType.Melee
				sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
				sender.backgroundColor = redColor
			}
			delegate?.heroFilterChanged(attackType, roles: roles)
		case 4:
			//initi
			roleButtonTouched(sender, role: HeroRole.Initiator)
		case 5:
			//carry
			roleButtonTouched(sender, role: HeroRole.Carry)
		case 6:
			roleButtonTouched(sender, role: HeroRole.Nuker)
		case 7:
			roleButtonTouched(sender, role: HeroRole.Pusher)
		case 8:
			roleButtonTouched(sender, role: HeroRole.Support)
		case 9:
			roleButtonTouched(sender, role: HeroRole.Escape)
		case 10:
			roleButtonTouched(sender, role: HeroRole.Disabler)
		case 11:
			roleButtonTouched(sender, role: HeroRole.Jungler)
		case 12:
			roleButtonTouched(sender, role: HeroRole.Durable)
		case 13:
			roleButtonTouched(sender, role: HeroRole.LaneSupport)
		default:
			break
			
		}
	}

}
