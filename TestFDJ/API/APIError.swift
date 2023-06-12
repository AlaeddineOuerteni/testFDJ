//
//  APIError.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

/// JSON alias that represents a default JSON Object
typealias JSONDictionary = [String: Any]

struct APIError: Error, CustomStringConvertible {
    enum ErrorType {
        /// CannotFetch: the request could not been made, network error, no response
        case cannotFetch
        /// EmptyData: the result can not be parsed, http body is null
        case emptyData
        /// RequestFailed: the api sent an error message, status code is not acceptable
        case requestFailed
        /// ObjectMapping: the service could not map data, json deserialization failed
        case objectMapping
        /// Could not perform request, authentication is required, 401
        case authenticationRequired
        /// Could not build request
        case badRequest
        /// Server returned an invalid response
        case invalidResponse
        /// Unknown error
        case unknown
        /// Not Found (404)
        case notFound
    }

    let type: ErrorType
    let message: String
    let rawResponse: JSONDictionary?
    let statusCode: Int?

    init(type: ErrorType, message: String, rawResponse: JSONDictionary? = nil, statusCode: Int? = nil) {
        self.type = type
        self.message = message
        self.rawResponse = rawResponse
        self.statusCode = statusCode
    }

    var description: String {
        message
    }
}
