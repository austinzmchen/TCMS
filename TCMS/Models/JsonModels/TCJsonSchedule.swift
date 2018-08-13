//
//  TCJsonSchedule.swift
//  TCMS
//
//  Created by Austin Chen on 2018-08-11.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import ACSyncKit

open class TCJsonSchedule: ACSyncableJsonRecord {
    var title: String?
    var desc: String?
    var startAt: Date?
    var duration: Int?
    var notes: String?
    var images: [TCJsonImage] = []
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        desc <- map["desc"]
        startAt <- (map["startAt"], ISO8601DateTransform())
        duration <- map["duration"]
        notes <- map["notes"]
        images <- map["images"]
    }
}
