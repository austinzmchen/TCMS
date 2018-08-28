//
//  AppDelegate+Orientation.swift
//  TCMS
//
//  Created by Austin Chen on 2018-08-27.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import Foundation

extension AppDelegate {
    
    // MARK: instance methods
    func lockOrientation(to mask: UIInterfaceOrientationMask) {
        lockedOrientation = mask
    }
    
    func unlockOrientation() {
        lockedOrientation = .all
    }
    
    /*
     /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
     static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
     self.lockOrientation(orientation)
     UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
     }
     */
    
    // delegate callbacks
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.lockedOrientation
    }
}
