//
//  HeroDetailViewController.swift
//  DotaWatcher
//
//  Created by lunner on 10/3/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit
let grayWhiteColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
@available(iOS 9.0, *)
class HeroDetailViewController: UIViewController, UIScrollViewDelegate {

	@IBOutlet weak var heroNameLabel: UILabel!
	@IBOutlet weak var heroFullImageView: UIImageView!
	@IBOutlet weak var attackTypeLabel: UILabel!
	@IBOutlet weak var rolesLabel: UILabel!
	@IBOutlet weak var heroVertImageView: UIImageView!
	@IBOutlet weak var intImageView: UIImageView!
	@IBOutlet weak var intValueLabel: UILabel!
	@IBOutlet weak var agiImageView: UIImageView!
	@IBOutlet weak var agiValueLabel: UILabel!
	@IBOutlet weak var strImageView: UIImageView!
	@IBOutlet weak var strValueLabel: UILabel!
	@IBOutlet weak var attackImageView: UIImageView!
	@IBOutlet weak var moveSpeedImageView: UIImageView!
	@IBOutlet weak var defenseImageView: UIImageView!
	@IBOutlet weak var attackValueLabel: UILabel!
	@IBOutlet weak var moveSpeedValueLabel: UILabel!
	@IBOutlet weak var defenseValueLabel: UILabel!
	
	@IBOutlet weak var abilitiesStackView: UIStackView! // hero's ability num is not certain use it to add ability
	
	
	@IBOutlet weak var loreTextView: UITextView!
	
	// TODO: onle one is connected.
	@IBOutlet var level1AttributesLabels: [UILabel]!
	@IBOutlet var level15AttributesLabels: [UILabel]!
	@IBOutlet var level25AttributesLabels: [UILabel]!
	
	@IBOutlet weak var sightRangeLabel: UILabel!
	@IBOutlet weak var attackRangeLabel: UILabel!
	@IBOutlet weak var missileSpeedLabel: UILabel!
	
	@IBOutlet weak var statsBottomRedView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	var hero: Hero!
	
	var viewInitializationDone = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		scrollView.delegate = self
		scrollView.scrollEnabled = true
		setup()
		let height = statsBottomRedView.convertPoint(CGPointMake(0, 0), toView: self.view).y + 2000
		
		scrollView.contentSize = CGSizeMake(self.view.bounds.width, height)
		
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if !self.viewInitializationDone {
			self.viewInitializationDone = true
			
			let height = statsBottomRedView.convertPoint(CGPointMake(0, 0), toView: self.view).y + 2000
			
			scrollView.contentSize = CGSizeMake(self.view.bounds.width, height)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func setup() {
		heroNameLabel.text = LUUtils.getName(hero.name).uppercaseString
		heroFullImageView.image = UIImage(data: hero.fullImage.image)
		attackTypeLabel.text = hero.atk_type
		rolesLabel.text = " - " + hero.roles
		heroVertImageView.image = UIImage(data: hero.portraitImage.image)
		switch hero.primary_attribute {
		case "int":
			let imageURL = NSBundle.mainBundle().URLForResource("overviewicon_primary_int", withExtension: "png")
			let intImage = UIImage(data: NSData(contentsOfURL: imageURL!)!)
			intImageView.image = intImage
		case "agi":
			let imageURL = NSBundle.mainBundle().URLForResource("overviewicon_primary_agi", withExtension: "png")
			//agiImageView.image = UIImage(data: <#T##NSData#>, scale: <#T##CGFloat#>)
			agiImageView.image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
		case "str":
			let imageURL = NSBundle.mainBundle().URLForResource("overviewicon_primary_str", withExtension: "png")
			strImageView.image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
		default:
			break
		}
		intValueLabel.text = hero.int
		agiValueLabel.text = hero.agi
		strValueLabel.text = hero.str
		
		attackValueLabel.text = hero.dmg
		moveSpeedValueLabel.text = hero.move_spd.stringValue
		defenseValueLabel.text = hero.armor.stringValue
		
		// remove arrangedSubviews from nib
		for subview in abilitiesStackView.arrangedSubviews {
			abilitiesStackView.removeArrangedSubview(subview)
			subview.removeFromSuperview()
		}
		for abilityElement in hero.abilities {
			let ability = abilityElement as! Ability
			let abilityStackView = UIStackView()
			abilityStackView.axis = .Horizontal
			let abilityImageView = UIImageView()
			abilityImageView.image = UIImage(data: ability.image_hp1.image)
			abilityImageView.contentMode = .ScaleAspectFit
			//set gesture
			let tapGesture = UITapGestureRecognizer(target: self, action: "abilityTaped:")
			tapGesture.numberOfTapsRequired = 2
			tapGesture.numberOfTouchesRequired = 1
			abilityImageView.addGestureRecognizer(tapGesture)

			
			let abilityDesStackView = UIStackView()
			abilityDesStackView.axis = .Vertical
			let label = UILabel()
			label.text = ability.name
			label.font = UIFont.systemFontOfSize(17.0)
			label.textColor = grayWhiteColor
			label.textAlignment = .Left
			let textView = UITextView()
			textView.textAlignment = .Left
			textView.text = ability.desc
			textView.editable = false
			textView.showsHorizontalScrollIndicator = false
			textView.backgroundColor = UIColor(red: 24/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
			textView.font = UIFont.systemFontOfSize(10.0)
			textView.textColor = grayWhiteColor
			abilityDesStackView.addArrangedSubview(label)
			abilityDesStackView.addArrangedSubview(textView)
			abilityDesStackView.distribution = .Fill
			abilityDesStackView.alignment = .Fill
			
			abilityStackView.addArrangedSubview(abilityImageView)
			abilityStackView.addArrangedSubview(abilityDesStackView)
			abilityStackView.spacing = 10.0
			
			abilityStackView.distribution = .Fill
			abilityStackView.alignment = .Fill
			
			// set imageview height, width
			abilityStackView.addConstraint(NSLayoutConstraint(item: abilityImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 90.0))
			abilityStackView.addConstraint(NSLayoutConstraint(item: abilityImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 90.0))
			
			abilitiesStackView.addArrangedSubview(abilityStackView)
			
			self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1.0, constant: -160.0))
			
			
			
		}
		
		// BIO
		loreTextView.text = hero.lore
		loreTextView.textColor = grayWhiteColor
		self.view.addConstraint(NSLayoutConstraint(item: loreTextView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1.0, constant: -70.0))
		// stats
		for levelAttributeElement in hero.levelAttributes {
			let levelAttribute = levelAttributeElement as! LevelAttribute
			switch levelAttribute.level {
			case 1:
				level1AttributesLabels[0].text = levelAttribute.hit_points.stringValue
				level1AttributesLabels[1].text = levelAttribute.mana.stringValue
				level1AttributesLabels[2].text = levelAttribute.damage
				level1AttributesLabels[3].text = levelAttribute.armor.stringValue
			case 15:
				level15AttributesLabels[0].text = levelAttribute.hit_points.stringValue
				level15AttributesLabels[1].text = levelAttribute.mana.stringValue
				level15AttributesLabels[2].text = levelAttribute.damage
				level15AttributesLabels[3].text = levelAttribute.armor.stringValue
			case 25:
				level25AttributesLabels[0].text = levelAttribute.hit_points.stringValue
				level25AttributesLabels[1].text = levelAttribute.mana.stringValue
				level25AttributesLabels[2].text = levelAttribute.damage
				level25AttributesLabels[3].text = levelAttribute.armor.stringValue
			default:
				break
			}
		}
		
		sightRangeLabel.text = hero.sight_range
		attackRangeLabel.text = hero.atk_range.stringValue
		//missileSpeedLabel.text = hero.missile_spd
		if hero.missile_spd == 0 {
			missileSpeedLabel.text = "N/A"
		} else {
			missileSpeedLabel.text = hero.missile_spd.stringValue
		}

	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func backButtonTouched(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: Tap Gesture
	func abilityTaped(gesture: UITapGestureRecognizer) {
		// TODO: show ability detail
		var i: Int
		for i=0; i<abilitiesStackView.arrangedSubviews.count; i++ {
			let abilityStackView = abilitiesStackView.arrangedSubviews[i]
			let imageView = (abilityStackView as! UIStackView).arrangedSubviews[0]
			let location = gesture.locationInView(imageView)
			if imageView.bounds.contains(location) {
				break
			}
		}
		let ability = self.hero.abilities[i] as! Ability
		
		let abilityDetailCrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AbilityDetailViewController") as! AbilityDetailViewController
		abilityDetailCrl.ability = ability 
		showViewController(abilityDetailCrl, sender: self)
		
	}
	
	// MARK: ScrollView delegate
	func scrollViewDidScroll(scrollView: UIScrollView) {
		print("scroll in srollview")
	}
}
