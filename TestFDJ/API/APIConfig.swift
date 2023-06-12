//
//  APIConfig.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

/// Simple Config for API
final class APIConfig {

    /// Shared Instance
    /// Holding configuration information for API
    static let sharedInstance = APIConfig()

    /// Default Time Out Request
    let timeOutRequest = 60.0

    /// Redesign host name
    let restHost = RestHost.prod
}
