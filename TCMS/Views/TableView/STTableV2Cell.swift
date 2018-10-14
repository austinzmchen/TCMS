//
//  STTableV2Cell.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-08-24.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import ACKit

class STTableV2Cell: UITableViewCell {
    
    @IBOutlet weak var bottomBorderConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var upNextView: ACView!
    //    @IBOutlet weak var upNextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    //    @IBOutlet weak var genreLogoImageView: UIImageView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgGradientView: ACGradientView!
    @IBOutlet weak var uncensorLabel: UILabel!
    
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.image = UIImage(named: "imgPlaceholder")
        imgView.contentMode = .scaleAspectFit
    }
    
    var isUpNext: Bool = false {
        didSet {
            self.upNextView.isHidden = !isUpNext
        }
    }
    
    var isUncensored: Bool = false {
        didSet {
            self.uncensorLabel.isHidden = !isUncensored
        }
    }
    
    func setGenre(title:String?, genreIcon iconName: String?) {
        if let _ = iconName {
            //genreLogoImageView.sd_setImage(with: URL(string: iName))
            genreLabel.text = ""
        } else {
            //genreLogoImageView.image = nil
            genreLabel.text = title
        }
    }
}

fileprivate let kTopBorderHeightBeforeAnim: CGFloat = 15.0
fileprivate let kTopBorderHeightNormal: CGFloat = 1.0
