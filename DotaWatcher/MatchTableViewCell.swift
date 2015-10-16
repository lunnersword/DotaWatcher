//
//  MatchTableViewCell.swift
//  DotaWatcher
//
//  Created by lunner on 10/8/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
	
	@IBOutlet weak var campLabel: UILabel!
	
	@IBOutlet weak var heroImage: UIImageView!
	
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var lobbyTypeLabel: UILabel!
	

	

	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
