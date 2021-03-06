//
//  TCDetailViewController.swift
//  TCMS
//
//  Created by Austin Chen on 2018-09-27.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import ACKit

class TCDetailViewController: UIViewController {
    
    @IBOutlet weak var elasticHeaderView: ElasticView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: ACGradientView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // methods
    var noteTokenBag = ACNoteObserverTokenBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.contentInset = .init(top: 10, left: 15, bottom: 10, right: 15)
        
        elasticHeaderView.maxExpandableHeight = 376
        elasticHeaderView.minExpandableHeight = 140
        
        addOrientationChangeObserver()
    }
}

extension TCDetailViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // add expanding
        let offsetY = scrollView.contentOffset.y
        elasticHeaderView.cOffsetY = offsetY
        
        // add elasticity
        if scrollView.contentOffset.y < 0 {
            let y = abs(scrollView.contentOffset.y)
            
            elasticHeaderView.elasticZoomConstant = y
        } else {
            var ratio = 1 - (1.0 / (elasticHeaderView.maxExpandableHeight - elasticHeaderView.minExpandableHeight)) * offsetY
            ratio = max(ratio, 0) // ratio > 0
            // add blur
            blurView.alpha = 1 - ratio
        }
    }
}
