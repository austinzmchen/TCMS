//
//  TCEventProcessor.swift
//  TCMS
//
//  Created by Austin Chen on 2018-08-11.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import Foundation
import ACSyncKit

protocol TCEventProcessorType: ACSyncableProcessorType {}

@objc class TCEventProcessor: NSObject, TCEventProcessorType {
    
    let syncContext: ACSyncContext
    required init (context: ACSyncContext) {
        self.syncContext = context
    }
    
    func sync(_ completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
        
    }
}
