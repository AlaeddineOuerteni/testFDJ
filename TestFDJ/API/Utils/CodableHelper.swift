//
//  CodableHelper.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import Foundation

final class CodableHelper {
    final class func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base64
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: data)
    }

    final class func encode<T: Encodable>(_ value: T, prettyPrint: Bool = false) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = (prettyPrint ? .prettyPrinted : [])
        encoder.dataEncodingStrategy = .base64
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(value)
    }
}

extension CodableHelper {
    static func decode<T: Decodable>(_ type: T.Type, from json: JSONDictionary) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try decode(type, from: jsonData)
    }

    static func decode<T: Decodable>(_ type: T.Type = T.self, json: Any) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: json)
        return try CodableHelper.decode(type, from: data)
    }
}
