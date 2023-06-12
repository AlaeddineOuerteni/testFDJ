//
//  XCTestCase+Utils.swift
//  TestFDJTests
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import XCTest

@testable import TestFDJ

extension XCTestCase {
    static func decode<T: Decodable>(from file: String, objType: T.Type) -> T {
        let bundle = Bundle(for: RestTestRequester.self)
        let url = bundle.url(forResource: file, withExtension: "json")
        let data = url.flatMap { try? Data(contentsOf: $0) }
        let object = data.flatMap { try? CodableHelper.decode(objType, from: $0) }

        do {
            let object = try CodableHelper.decode(objType, from: data!)
            return object
        } catch { }

        return object!
    }
}
