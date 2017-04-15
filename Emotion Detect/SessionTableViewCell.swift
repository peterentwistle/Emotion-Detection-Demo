//
//  SessionTableViewCell.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 20/03/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

	@IBOutlet weak var sessionLabel: UILabel!
	@IBOutlet weak var happinessPercent: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
