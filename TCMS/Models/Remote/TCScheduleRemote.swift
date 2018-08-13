//
//  TCScheduleRemote.swift
//  TCMS
//
//  Created by Austin Chen on 2018-08-12.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire
import ACSyncKit

protocol TCScheduleRemoteType {
    func fetchCollections(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<TCJsonSchedulesResult>) -> ())
}

class TCScheduleRemote: ACRemote, TCScheduleRemoteType {
    
    func fetchCollections(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<TCJsonSchedulesResult>) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let includeAll = "?$include=*"
        
        let request = self.alamoFireManager.request("http://35.173.187.144:3000" + path , headers: self.remoteSession?.postAuthenticationHttpHeaders)
        request.responseObject(queue: ACRemoteSettings.concurrentQueue) { (response: DataResponse<TCJsonSchedulesResult>) in
            if response.isValid,
                let v = response.result.value {
                completion(ACRemoteResult.success(v))
            } else {
                completion(ACRemoteResult.failure(response.error))
            }
        }
    }
}

typealias TCJsonSchedulesResult = TCJsonResult<TCJsonSchedule>
