//
//  RestTestRequester.swift
//  TestFDJTests
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import Foundation
import RxSwift

@testable import TestFDJ

final class RestTestRequester: RestRequesterProtocol {
    let jsonMappings: [String: String]

    init(jsonMappings: [String: String]) {
        self.jsonMappings = jsonMappings
    }

    private func findFileName(path: String) -> String? {
        for (pattern, filename) in jsonMappings {
            // swiftlint:disable:next force_try
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            if regex.firstMatch(in: path, options: [], range: NSRange(location: 0, length: path.count)) != nil {
                return filename
            }
        }
        return nil
    }

    func query<I, O: Codable>(
        request: RestRequest<I>,
        mappingOptions: RestWorker.MappingOptions = .none
    ) -> Single<O> {
        guard let fileName = findFileName(path: request.path) else {
            return Single.error(
                APIError(type: .cannotFetch, message: "Cannot find mocked json file for `\(request.path)`.")
            )
        }
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.url(forResource: fileName, withExtension: "") else {
            return Single.error(APIError(type: .cannotFetch, message: "Failed to construct path for \(fileName)"))
        }
        do {
            let data = try Data(contentsOf: filePath)
            let obj = try CodableHelper.decode(O.self, from: data)
            return Single.just(obj)
        } catch {
            return Single.error(APIError(type: .badRequest, message: String(describing: error)))
        }
    }
}
