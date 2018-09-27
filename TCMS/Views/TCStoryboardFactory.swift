//
//  TCStoryboardFactory.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-28.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

class TCStoryboardFactory: NSObject {
    
    static func storyboard(byFileName fileName: String) -> UIStoryboard? {
        return UIStoryboard(name: fileName, bundle: nil)
    }
   
    static var drawerStoryboard: UIStoryboard {
        return UIStoryboard(name: "Drawer", bundle: nil)
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static var ptStuffStoryboard: UIStoryboard {
        return UIStoryboard(name: "PTStuff", bundle: nil)
    }
    
    static var debugStoryboard: UIStoryboard {
        return UIStoryboard(name: "Debug", bundle: nil)
    }
    
    static var settingsStoryboard: UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: nil)
    }
    
    static var utilityStoryboard: UIStoryboard {
        return UIStoryboard(name: "Utility", bundle: nil)
    }
}
