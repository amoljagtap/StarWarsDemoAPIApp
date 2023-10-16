//
//  HTTPRequestBody.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation

protocol HTTPRequestBody {
    var isEmpty: Bool { get }
    var additionalHeaders: [String: String] { get }
    func encode() throws -> Data
}

extension HTTPRequestBody {
    var isEmpty: Bool { return false }
    var additionalHeaders: [String: String] { return [:] }
}

struct EmptyBody: HTTPRequestBody {
    let isEmpty = true

    init() { }
    func encode() throws -> Data { Data() }
}

struct JSONBody: HTTPRequestBody {
    let isEmpty: Bool = false
    var additionalHeaders = [
        "Content-Type": "application/json; charset=utf-8"
    ]
    
    private let _encode: () throws -> Data
    
    init<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) {
        self._encode = { try encoder.encode(value) }
    }
    
    func encode() throws -> Data {
        return try _encode()
    }
}
