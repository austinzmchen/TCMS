//
//  TCJsonResult.swift
//  TCMS
//
//  Created by Austin Chen on 2018-08-11.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import ACSyncKit

open class TCJsonResult<T: Mappable>: ACSyncableJsonRecord {
    var data: [T] = []
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
    }
}
