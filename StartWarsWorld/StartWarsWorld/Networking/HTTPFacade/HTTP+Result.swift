//
//  HTTP+Result.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation

typealias HTTPResult = Result<HTTP.Response, HTTP.NetworkError>

extension HTTP {
    struct NetworkError: Error {
        
        static let invalidRequest = NetworkError(code: .invalidRequest,
                                                 request: Request(endpoint: .init()),
                                                 response: nil,
                                                 underlyingError: nil)
        
        let code: Code
        
        let request: HTTP.Request
        
        let response: HTTP.Response?
        
        let underlyingError: Error?
        
        enum Code {
            case invalidRequest
            case cannotConnect
            case cancelled
            case insecureConnection
            case invalidResponse
            case clientError
            case serverError
            case unknown
        }
    }
}

extension HTTPResult {
    
    var request: HTTP.Request {
        switch self {
            case .success(let response): return response.request
            case .failure(let error): return error.request
        }
    }
    
    var response: HTTP.Response? {
        switch self {
            case .success(let response): return response
            case .failure(let error): return error.response
        }
    }
}
