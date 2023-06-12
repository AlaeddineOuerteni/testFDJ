//
//  RestRequester.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import Foundation
import RxSwift

protocol RestRequesterProtocol {
    func query<I, O: Codable>(request: RestRequest<I>, mappingOptions: RestWorker.MappingOptions) -> Single<O>
}

extension RestRequesterProtocol {
    func query<I, O: Codable>(request: RestRequest<I>) -> Single<O> {
        query(request: request, mappingOptions: .none)
    }
}

struct RestRequester: RestRequesterProtocol {
    let worker: RestWorkerProtocol

    init(worker: RestWorkerProtocol = RestWorker()) {
        self.worker = worker
    }
    
    func query<I, O: Codable>(request: RestRequest<I>, mappingOptions: RestWorker.MappingOptions = .none) -> Single<O> {
        worker.fetchRequest(request: request, mappingOptions: mappingOptions)
    }
}
