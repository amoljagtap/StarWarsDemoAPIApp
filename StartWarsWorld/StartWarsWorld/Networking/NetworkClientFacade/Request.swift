//
//  Request.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation
import Combine

enum ParsingError: Error {
    case failedDecodeModel
}

struct Request<Response> {
    let underlyingRequest: HTTP.Request
    let decode: (HTTP.Response) throws -> Response

    init(underlyingRequest: HTTP.Request, decode: @escaping (HTTP.Response) throws -> Response) {
        self.underlyingRequest = underlyingRequest
        self.decode = decode
    }
}

extension Request where Response: Decodable {

    init(underlyingRequest: HTTP.Request) {
        self.init(underlyingRequest: underlyingRequest, decoder: JSONDecoder())
    }

    init<D: TopLevelDecoder>(underlyingRequest: HTTP.Request, decoder: D) where D.Input == Data {
        self.init(underlyingRequest: underlyingRequest) {
            guard let data = $0.body else {
                throw ParsingError.failedDecodeModel
            }
            return try decoder.decode(Response.self, from: data)
        }
    }
}
