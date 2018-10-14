//
//  CustomCell.swift
//  HelloCalendar
//
//  Created by JayT on 2017-04-06.
//  Copyright © 2017 patchTheCode. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dotsStackview: UIStackView!
    
    @IBOutlet weak var dot1: UIView!
    @IBOutlet weak var dot2: UIView!
    @IBOutlet weak var plusView: UIView!
    
    var eventsCount: Int = 0 {
        didSet {
            if eventsCount == 0 {
                dotsStackview.isHidden = true
            } else {
                dotsStackview.isHidden = false
                
                if eventsCount == 1 {
                    dot2.isHidden = true
                    plusView.isHidden = true
                } else if eventsCount == 2 {
                    dot2.isHidden = false
                    plusView.isHidden = true
                } else {
                    plusView.isHidden = false
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dotsStackview.isHidden = false
        dotsStackview.subviews.forEach{$0.isHidden = false}
    }
}
