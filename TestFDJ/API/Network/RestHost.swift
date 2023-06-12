//
//  RestHost.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

enum RestHost {
    case prod
    case staging

    private static let api = "api/v1/json/50130162"
    private static let prodValue = "https://www.thesportsdb.com"
    private static let stagingValue = "https://www.thesportsdb.com"

    var baseUrl: String {
        switch self {
        case .prod:
            return Self.prodValue
        case .staging:
            return Self.stagingValue
        }
    }

    var api: String {
        switch self {
        case .prod, .staging:
            return Self.api
        }
    }
}
