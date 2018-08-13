//
//  TCJsonImage.swift
//  TCMS
//
//  Created by Austin Chen on 2018-08-11.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import ACSyncKit

open class TCJsonImage: ACSyncableJsonRecord {
    var width: Int?
    var height: Int?
    var path: String?
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        
        width <- map["width"]
        height <- map["height"]
        path <- map["path"]
    }
}
