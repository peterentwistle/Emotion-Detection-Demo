//
//  ResultsTableViewCell.swift
//  Emotion Detect
//
//  Created by Peter Entwistle on 18/03/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var emotionImage: UIImageView!
    @IBOutlet weak var emotionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
