//
//  BattleDetailTableViewCell.swift
//  DotaWatcher
//
//  Created by lunner on 10/8/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit

class BattleDetailTableViewCell: UITableViewCell {

	//@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var heroImageView: UIImageView!
	@IBOutlet var itemImageViews: [UIImageView]!
	
	@IBOutlet weak var detailView: UIView!
	
	@IBOutlet weak var heroNameLabel: UILabel!
	@IBOutlet weak var lastHitsLabel: UILabel!
	@IBOutlet weak var goldPerMinLabel: UILabel!
	@IBOutlet weak var goldSpendLabel: UILabel!
	@IBOutlet weak var heroDamageLabel: UILabel!
	@IBOutlet weak var towerDamageLabel: UILabel!
	@IBOutlet weak var goldRemianLabel: UILabel!
	@IBOutlet weak var deniesLabel: UILabel!
	@IBOutlet weak var xpPerMinLabel: UILabel!
	
	@IBOutlet weak var assistsLabel: UILabel!
	@IBOutlet weak var deathsLabel: UILabel!
	@IBOutlet weak var killsLabel: UILabel!
	@IBOutlet weak var heroLevelLabel: UILabel!
	
	//var isHide = true
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.detailView.hidden = true
    }
	

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//		isHide = !isHide
//		UIView.animateWithDuration(0.5, animations: {
//			[unowned self] in	
//			self.detailView.hidden = self.isHide
//		})
		print("\(self.detailView.hidden)")

    }
    
}
