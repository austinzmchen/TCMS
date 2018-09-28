//
//  DetailViewController2.swift
//  TCMS
//
//  Created by Austin Chen on 2018-09-27.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import ACKit

class DetailViewController2: UIViewController {
    
    @IBOutlet weak var elasticHeaderView: STSeriesElasticHeaderView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: ACGradientView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // methods
    //    private var noteTokenBag = ACNoteObserverTokenBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.contentInset = .init(top: 10, left: 15, bottom: 10, right: 15)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil, queue: nil) { [weak self] (note) in
            guard let `self` = self,
                self.isViewLoaded && (self.view.window != nil) else { return }
            
            if UIDevice.current.orientation.isPortrait {
                self.textView.delegate = self
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait {
            blurView.isHidden = false
            gradientView.isHidden = false
            infoView.backgroundColor = .black
        } else if UIDevice.current.orientation.isLandscape {
            blurView.isHidden = true
            gradientView.isHidden = true
            infoView.backgroundColor = .clear
            
            textView.delegate = nil // prevent scroll view auto scroll
        }
    }
    
    func didScroll(_ scrollView: UIScrollView) {
        /*
         guard !(videoPlayerView.videoPlayer?.isStarted ?? false) //commented bcoz isStarted value updates slowly and may not work everytime. replaced with the below code
         else { return }
         */
        
        // add elasticity
        elasticHeaderView.expandIfNeeded(whenScroll: scrollView)
        
        // add expanding
        elasticHeaderView.stretchIfNeeded(whenScroll: scrollView)
        
        // add custom
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            var ratio = 1 - (1.0 / (elasticHeaderView.maxExpandableHeight - elasticHeaderView.minExpandableHeight)) * offsetY
            ratio = max(ratio, 0) // ratio > 0
            
            var ratioX2 = 1 - (1.0 / (elasticHeaderView.maxExpandableHeight - elasticHeaderView.minExpandableHeight)) * (offsetY * 2)
            ratioX2 = max(ratioX2, 0) // ratio > 0
            
            // add blur
            blurView.alpha = 1 - ratio
            
            //            // fading
            //            descLabel.alpha = ratioX2
            //
            //            // shrink or expand descLabel
            //            if descLabelOrigHeight == nil {
            //                descLabelOrigHeight = descLabel.constraints.filter{$0.firstAttribute == .height}.first?.constant
            //            }
            //            if let doh = descLabelOrigHeight {
            //                descLabel.constraints.filter{$0.firstAttribute == .height}.first?.constant = doh * ratio + 10.0
            //            }
        }
    }
}

extension DetailViewController2: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(scrollView)
    }
}
