//
//  TCDetailViewController+Orientation.swift
//  TCMS
//
//  Created by Austin Chen on 2018-10-07.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit

extension TCDetailViewController {

    func addOrientationChangeObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil, queue: nil)
        { [weak self] (note) in
            guard let `self` = self,
                self.isViewLoaded && (self.view.window != nil) else { return }
            
            if UIDevice.current.orientation.isPortrait {
                self.textView.delegate = self
            }
        }.addDisposableToken(to: noteTokenBag)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustOrientation()
    }
    
    func adjustOrientation() {
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
}
