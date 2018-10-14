//
//  TCEventRemote.swift
//  TCMS
//
//  Created by Austin Chen on 2018-08-11.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire
import ACSyncKit

protocol TCEventRemoteType {
    func fetchCollections(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<TCJsonEventsResult>) -> ())
}

class TCEventRemote: ACRemote, TCEventRemoteType {
    
    func fetchCollections(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<TCJsonEventsResult>) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let includeAll = "?$include=*"
        
        let request = self.alamoFireManager.request("\(baseUrl)/events\(path)", headers: self.remoteSession?.postAuthenticationHttpHeaders)
        request.responseObject(queue: ACRemoteSettings.concurrentQueue) { (response: DataResponse<TCJsonEventsResult>) in
            if response.isValid,
                let v = response.result.value {
                completion(ACRemoteResult.success(v))
            } else {
                completion(ACRemoteResult.failure(response.error))
            }
        }
    }
}

typealias TCJsonEventsResult = TCJsonResult<TCJsonEvent>
