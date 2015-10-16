//
//  AbilityDetailViewController.swift
//  DotaWatcher
//
//  Created by lunner on 10/4/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit

class AbilityDetailViewController: UIViewController {
	var ability: Ability!
	
	@IBOutlet weak var abilityImageView: UIImageView!
	@IBOutlet weak var abilityNameLabel: UILabel!
	
	@IBOutlet weak var abilityDescriptionTextView: UITextView!
	
	@IBOutlet weak var cooldownLabel: UILabel!
	@IBOutlet weak var manaCostLabel: UILabel!
	
	@IBOutlet weak var leftDetailsStackView: UIStackView!
	@IBOutlet weak var rightDetailsStackView: UIStackView!
	
	@IBOutlet weak var loreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setup()
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
	
	func  setup() {
		abilityImageView.image = UIImage(data: ability.image_hp2.image)
		abilityNameLabel.text = ability.name
		abilityDescriptionTextView.text = ability.desc
		cooldownLabel.text = ability.cooldown?.stringValue
		manaCostLabel.text = ability.mana_cost
		setupDetailViews()
		
		// TODO: video
		
		loreLabel.text = ability.lore
		
	}
	func getLeftDetails(detailStr: String) -> [String] {
		var leftDetails = [String]()
		for row in detailStr.componentsSeparatedByString("\n") {
			
			let keyValue = row.componentsSeparatedByString("\t")
			leftDetails.append(keyValue[0])
			leftDetails.append(keyValue[1])
			
			
		}
		return leftDetails
	}
	
	func setupDetailViews() {
		let leftDetails = getLeftDetails(ability.left_details)
		
		for subview in leftDetailsStackView.arrangedSubviews {
			leftDetailsStackView.removeArrangedSubview(subview)
			subview.removeFromSuperview()
		}
		
		for var i=0; i<leftDetails.count; i=i+2 {
			let key = leftDetails[i]
			let value = leftDetails[i+1]
			
			let rowStackView = UIStackView()
			rowStackView.axis = .Horizontal
			rowStackView.distribution = .Fill
			rowStackView.alignment = .Fill
			
			let keyLabel = UILabel()
			keyLabel.text = key
			keyLabel.textColor = grayWhiteColor
			keyLabel.font = UIFont.systemFontOfSize(15)
			keyLabel.textAlignment = .Left
			
			let valueLabel = UILabel()
			valueLabel.textAlignment = .Left
			valueLabel.textColor = UIColor.whiteColor()
			valueLabel.font = UIFont.systemFontOfSize(15)
			valueLabel.text = value 
			
			rowStackView.addArrangedSubview(keyLabel)
			rowStackView.addArrangedSubview(valueLabel)
			
			leftDetailsStackView.addArrangedSubview(rowStackView)
			
		}
		
		for subview in rightDetailsStackView.arrangedSubviews {
			rightDetailsStackView.removeArrangedSubview(subview)
			subview.removeFromSuperview()
		}
		if ability.abilityDetails != nil {
			for element in ability.abilityDetails! {
				let detail = element as! AbilityDetail
				
				let rowStackView = UIStackView()
				rowStackView.axis = .Horizontal
				rowStackView.distribution = .Fill
				rowStackView.alignment = .Fill
				
				let keyLabel = UILabel()
				keyLabel.text = detail.name
				keyLabel.textAlignment = .Left
				keyLabel.textColor = grayWhiteColor
				keyLabel.font = UIFont.systemFontOfSize(15)
				
				let valueLabel = UILabel()
				valueLabel.text = detail.detail
				valueLabel.textAlignment = .Left
				valueLabel.textColor = UIColor.whiteColor()
				valueLabel.font = UIFont.systemFontOfSize(15)
				
				rowStackView.addArrangedSubview(keyLabel)
				rowStackView.addArrangedSubview(valueLabel)
				
				rightDetailsStackView.addArrangedSubview(rowStackView)
			}

		}
	}

}
