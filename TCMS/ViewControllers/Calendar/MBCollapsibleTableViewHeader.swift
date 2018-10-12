//
//  MBCollapsibleTableViewHeader.swift
//  MBNA
//
//  Created by Austin Chen on 2018-01-04.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import CollapsibleTableSectionViewController

enum MBCollapsibleTableViewHeaderSeparaterStyle: CGFloat {
    case none = -1 // value means the leading contraint constant
    case normal = 70
    case full = 0
}

enum MBCollapsibleTableViewHeaderCollapseStatus {
    case incollapsible
    case collapsed
    case expanded
}

class MBCollapsibleTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var bottomBorder: UIView!
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    var separatorStyle: MBCollapsibleTableViewHeaderSeparaterStyle = .normal {
        didSet {
            let bottomBorderLeadConstraint = bottomBorder.superview?.constraints.filter{$0.identifier == "kBottomBorderLeadConstraint"}.first
            
            switch separatorStyle {
            case .none:
                bottomBorderLeadConstraint?.constant = UIScreen.main.bounds.width
            case .normal:
                bottomBorderLeadConstraint?.constant = separatorStyle.rawValue
            case .full:
                let spacerHeight: CGFloat = 10
                let heightConstraint = bottomBorder.constraints.filter{$0.identifier == "kBottomBorderHeightConstraint"}.first
                heightConstraint?.constant = spacerHeight
                bottomBorderLeadConstraint?.constant = separatorStyle.rawValue
            }
        }
    }
    
    var collapseStatus: MBCollapsibleTableViewHeaderCollapseStatus = .incollapsible {
        didSet {
            switch collapseStatus {
            case .incollapsible:
                titleLabel.textColor = UIColor.black
                rightImageView.image = nil
            case .collapsed:
                titleLabel.textColor = UIColor.black
                rightImageView.image = UIImage(named: "expand_icon")
            case .expanded:
                titleLabel.textColor = UIColor.gray
                rightImageView.image = UIImage(named: "collapse_icon")
            }
        }
    }
    
    override func awakeFromNib() {
        //
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MBCollapsibleTableViewHeader.tapHeader(_:))))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 1
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let view = gestureRecognizer.view as? MBCollapsibleTableViewHeader else {
            return
        }
        
        _ = delegate?.toggleSection(view.section)
    }
}
