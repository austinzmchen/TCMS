//
//  STTableHeroCell.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-08-31.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import ACKit

class STTableHeroCell: UITableViewCell {

    @IBOutlet weak var parallaxView: KCParallaxView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var snacksCount: Int = 0 {
        didSet {
            subTitleLabel.text = String(format: "%d SNACKS", snacksCount)
        }
    }
}
