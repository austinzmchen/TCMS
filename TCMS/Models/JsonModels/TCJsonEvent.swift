//
//  TCJsonEvent.swift
//  TCMS
//
//  Created by Austin Chen on 2018-08-11.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import ACSyncKit

open class TCJsonEvent: ACSyncableJsonRecord {
    var title: String?
    var desc: String?
    var notes: String?
    var isFeatured = false
    var images: [TCJsonImage] = []
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        desc <- map["desc"]
        notes <- map["notes"]
        isFeatured <- map["isFeatured"]
        images <- map["images"]
    }
}
