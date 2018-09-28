//
//  STSeriesElasticHeaderView.swift
//  ACKit
//
//  Created by Austin Chen on 2017-09-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import ACKit

enum ACElasticViewStyle {
    case none
    case topFixed
    case centerFixed
}

enum ACElasticViewExpandStyle {
    case none
    case scale
    case bottomShift
}

class STSeriesElasticHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var eView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var eViewTopConstraint: NSLayoutConstraint!
    
    // used when SHIFTING expand/shrink
    @IBOutlet weak var eViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eViewBottomConstraint: NSLayoutConstraint!
    
    // used when scale elasticity
    @IBOutlet weak var eViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var eViewEqualHeightToContentViewConstraint: NSLayoutConstraint!
    
    var maxExpandableHeight: CGFloat {
        return 376
    }
    
    var minExpandableHeight: CGFloat = 211
    
    // MARK: life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.insertSubview(contentView, at: 0)
        
        // add the missing contrainst between xib contentView to self
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.clipsToBounds = true // in scale expand style, elastic view does not go out of bound of the container view
        eView.constraints.filter{ $0.firstAttribute == .height }.first?.constant = 211
        
        elasticStyle = .centerFixed // default to centerFixed
        expandStyle = .none
    }
    
    // MARK: elastic settings
    var elasticStyle: ACElasticViewStyle = .topFixed
    
    var elasticZoomConstant: CGFloat = 0 {
        didSet {
            switch elasticStyle {
            case .none:
                eViewTopConstraint.priority = UILayoutPriority(rawValue: 999)
                eViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
                eViewEqualHeightToContentViewConstraint.priority = UILayoutPriority(rawValue: 1)
                eViewCenterYConstraint.priority = UILayoutPriority(rawValue: 1)
            return // exit early
            case .topFixed:
                eViewTopConstraint.priority = UILayoutPriority(rawValue: 999)
                eViewCenterYConstraint.priority = UILayoutPriority(rawValue: 1)
            case .centerFixed:
                eViewTopConstraint.priority = UILayoutPriority(rawValue: 1)
                eViewCenterYConstraint.priority = UILayoutPriority(rawValue: 999)
            }
            
            eViewEqualHeightToContentViewConstraint.constant = elasticZoomConstant
        }
    }
    
    // MARK: expand settings
    
    var expandStyle: ACElasticViewExpandStyle = .bottomShift
    
    var cHeight: CGFloat = kDefaultMaxExpandableHeight {
        didSet {
            if cHeight >= maxExpandableHeight { // elasticity
                // turn off shift
                eViewBottomConstraint.priority = UILayoutPriority(rawValue: 1)
                eViewHeightConstraint.priority = UILayoutPriority(rawValue: 1)
                
                // turn on scale
                eViewEqualHeightToContentViewConstraint.priority = UILayoutPriority(rawValue: 999)
                eViewCenterYConstraint.priority = UILayoutPriority(rawValue: 1)
            } else { // expand & shrink
                switch expandStyle {
                case .none:
                    eViewTopConstraint.priority = UILayoutPriority(rawValue: 999)
                    eViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
                    
                    eViewBottomConstraint.priority = UILayoutPriority(rawValue: 1)
                    eViewEqualHeightToContentViewConstraint.priority = UILayoutPriority(rawValue: 1)
                    eViewCenterYConstraint.priority = UILayoutPriority(rawValue: 1)
                case .scale:
                    eViewBottomConstraint.priority = UILayoutPriority(rawValue: 1)
                    eViewHeightConstraint.priority = UILayoutPriority(rawValue: 1)
                    
                    eViewEqualHeightToContentViewConstraint.priority = UILayoutPriority(rawValue: 999)
                case .bottomShift:
                    // turn on shift
                    eViewBottomConstraint.priority = UILayoutPriority(rawValue: 999)
                    eViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
                    
                    // turn off scale
                    eViewEqualHeightToContentViewConstraint.priority = UILayoutPriority(rawValue: 1)
                }
            }
            
            let h = constraints.front{$0.firstAttribute == .height}
            h?.constant = cHeight
        }
    }
    
    func expandIfNeeded(whenScroll scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            guard offsetY < scrollView.contentSize.height - scrollView.bounds.height
                else { return }
            
            let h = maxExpandableHeight - min(maxExpandableHeight - minExpandableHeight, offsetY)
            cHeight = h
        } else {
            cHeight = maxExpandableHeight
        }
    }
    
    func stretchIfNeeded(whenScroll scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            let y = abs(scrollView.contentOffset.y)
            
            elasticZoomConstant = y
        }
    }
}

fileprivate var kDefaultMaxExpandableHeight: CGFloat = 300
