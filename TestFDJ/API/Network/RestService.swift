//
//  RestService.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import RxSwift

class RestService: NSObject {
    
    /// Requester
    let requester: RestRequesterProtocol
    
    init(requester: RestRequesterProtocol = RestRequester()) {
        self.requester = requester
    }
}
