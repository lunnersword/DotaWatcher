//
//  PlayerTableViewCell.swift
//  DotaWatcher
//
//  Created by lunner on 10/7/15.
//  Copyright © 2015 lunner. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

	@IBOutlet weak var dotaID: UILabel!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
