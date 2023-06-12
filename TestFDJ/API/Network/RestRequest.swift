//
//  RestRequest.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import Alamofire
import RxSwift

enum RestMethod {
    case GET
    case POST
    case DELETE
    case PATCH
    case PUT
}

/// REST API Request
///
/// `T` is the type of HTTP body
struct RestRequest<T: Encodable> {
    let httpMethod: RestMethod
    
    /// API method name
    let path: String
    /// Params if needed
    var params: [String: Any]
    /// Request body object
    var body: T?
    /// Request is multipart form-data
    let multipart: Bool
    let customHeaders: [String: String]?
    /// Define the URLEncoding style
    private let urlEncoder: URLEncoder

    private let baseUrl: String
    private let api: String
    
    init(
        httpMethod: RestMethod,
        baseUrl: String = APIConfig.sharedInstance.restHost.baseUrl,
        api: String = APIConfig.sharedInstance.restHost.api,
        path: String,
        params: [String: Any] = [:],
        body: T? = nil,
        multipart: Bool = false,
        customHeaders: [String: String]? = nil,
        urlEncoder: URLEncoder = .default
    ) {
        self.httpMethod = httpMethod
        self.baseUrl = baseUrl
        self.api = api
        self.path = path
        self.params = params
        self.body = body
        self.multipart = multipart
        self.customHeaders = customHeaders
        self.urlEncoder = urlEncoder
    }

    private func constructURLPath(baseURL: String, api: String, path: String) -> String {
        "\(baseURL)/\(api)/\(path)"
    }

    /**
     Generate url request without parameters
     - Returns: URL?
     */
    func generateUrl() -> URL? {
        urlEncoder
            .encode(path)
            .flatMap { URL(string: constructURLPath(baseURL: baseUrl, api: api, path: $0)) }
    }
}
