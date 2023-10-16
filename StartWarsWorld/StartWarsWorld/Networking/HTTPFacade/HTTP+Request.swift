//
//  HTTP+Request.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation

extension HTTP{
    struct Request {
        
        let endpoint: Endpoint
        var method: HTTP.Method = .get
        var headers: [String: String] = [:]
        var body: HTTPRequestBody = EmptyBody()
        
        func makeRequest() -> URLRequest? {
            var request = URLRequest(url: endpoint.url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            request.httpBody = try? body.encode()
            return request
        }
    }
}
