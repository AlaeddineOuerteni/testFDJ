//
//  RestWorker.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import Alamofire
import RxSwift

protocol RestWorkerProtocol {
    func fetchRequest<I, O: Codable>(request: RestRequest<I>, mappingOptions: RestWorker.MappingOptions) -> Single<O>
}

extension RestMethod {
    func toAlamofireMethod() -> Alamofire.HTTPMethod {
        switch self {
        case .POST: return .post
        case .PATCH: return .patch
        case .DELETE: return .delete
        case .PUT: return .put
        case .GET: return .get
        }
    }
}

/// Alamofire Wrapper for HTTP Requests
/// This worker implement the APIWorkerProtocol
struct RestWorker: RestWorkerProtocol {
    struct Param {
        let key: String
        let value: String
    }

    enum MappingOptions {
        case none
        case data
    }
    
    private let manager: Alamofire.Session
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIConfig.sharedInstance.timeOutRequest
        configuration.requestCachePolicy = .useProtocolCachePolicy

        // startRequestsImmediately -> Disable auto firing
        manager = Alamofire.Session(configuration: configuration, startRequestsImmediately: false)
    }

    // MARK: - Override RestWorkerProtocol methods
    
    func fetchRequest<I, O: Codable>(request: RestRequest<I>, mappingOptions: MappingOptions = .none) -> Single<O> {
        buildRequest(request).flatMap { req in
            Single<O>.create { observer in
                req.response(completionHandler: { response in
                    do {
                        observer(
                            .success(try validate(request: request, response: response, mappingOptions: mappingOptions))
                        )
                    } catch let error {
                        observer(.error(error))
                    }
                }).resume()
                return Disposables.create {
                    req.cancel()
                }
            }
        }
    }
    
    // MARK: - Request builders
    
    private func buildRequest<I>(_ request: RestRequest<I>) -> Single<DataRequest> {
        guard let url = request.generateUrl() else {
            return Single.error(APIError(type: .badRequest, message: "RestRequest.generateUrl() returns nil"))
        }
        let method = request.httpMethod.toAlamofireMethod()
        if let body = request.body, request.multipart == false {
            do {
                let data = try CodableHelper.encode(body)
                return Single.just(
                    manager.request(
                        url,
                        method: request.httpMethod.toAlamofireMethod(),
                        headers: [HTTPHeader(name: "Content-Type", value: "application/json")],
                        requestModifier: { afRequest in
                            afRequest.httpBody = data
                            guard let customHeaders = request.customHeaders else {
                                return
                            }
                            customHeaders.forEach { afRequest.setValue($1, forHTTPHeaderField: $0) }
                        }
                    )
                )
            } catch {
                return Single.error(APIError(type: .badRequest, message: error.localizedDescription))
            }
        } else {
            return Single.just(manager.request(url, method: method, parameters: request.params))
        }
    }
    
    // MARK: - Request validator
    
    private func errorTypeFor(statusCode: Int) -> APIError.ErrorType {
        switch statusCode {
        case 401: return .authenticationRequired
        case 404: return .notFound
        default: return .requestFailed
        }
    }

    private func validate<I, O: Codable>(request: RestRequest<I>, response: AFDataResponse<Data?>, mappingOptions: MappingOptions) throws -> O {
        let statusCode = response.response?.statusCode
        // Test network error
        guard response.error == nil else {
            let err = response.error!
            throw createApiError(path: request.path, type: .cannotFetch, statusCode: statusCode, message: err.localizedDescription)
        }
        // Get HTTP response
        guard let res = response.response else {
            throw createApiError(path: request.path, type: .cannotFetch, statusCode: statusCode, message: "No response")
        }
        // Test response status code
        guard acceptableStatusCodes.contains(res.statusCode) else {
            let type = errorTypeFor(statusCode: res.statusCode)
            let data = response.data ?? Data()
            let body = try? JSONSerialization.jsonObject(with: data) as? JSONDictionary
            // Parse body as ModelErrorResponse.ErrorDetail
            let errors = body?["errors"] as? [String: Any]
            let message = errors?["detail"] as? String ?? "Status code \(res.statusCode) is not acceptable"
            throw createApiError(path: request.path, type: type, statusCode: statusCode, message: message, rawBody: body)
        }
        // Get HTTP body data
        guard let data = response.data else {
            throw createApiError(path: request.path, type: .emptyData, statusCode: statusCode, message: "HTTP body is nil")
        }
        // Test JSON deserialize
        do {
            switch mappingOptions {
            case .none:
                return try CodableHelper.decode(O.self, from: data)
            case .data:
                let obj = try CodableHelper.decode(Response<Empty, O>.self, from: data)
                return obj.data
            }
        } catch {
            throw createApiError(
                path: request.path,
                type: .objectMapping,
                statusCode: statusCode,
                message: "JSON deserialization failed: \(error)"
            )
        }
    }
    
    // MARK: - Utilities
    private let acceptableStatusCodes = Array(200..<300)
    
    private func createApiError(
        path: String,
        type: APIError.ErrorType,
        statusCode: Int?, message: String,
        rawBody: JSONDictionary? = nil
    ) -> Error {
        APIError(type: type, message: message, rawResponse: rawBody, statusCode: statusCode)
    }
}
