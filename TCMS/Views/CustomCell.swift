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
    
    var eventsCount: Int = 0 {
        didSet {
            if eventsCount == 0 {
                dotsStackview.isHidden = true
            } else {
                dotsStackview.isHidden = false
                
                if eventsCount == 1 {
                    dotsStackview.subviews.first?.isHidden = true
                } else {
                    dotsStackview.subviews.first?.isHidden = true
                }
            }
        }
    }
}
