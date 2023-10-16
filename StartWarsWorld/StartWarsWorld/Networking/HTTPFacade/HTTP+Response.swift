//
//  HTTP+Response.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation

extension HTTP {
    struct Status: RawRepresentable {
        var rawValue: Int
    }
    
    struct Response {
        let request: HTTP.Request
        let response: HTTPURLResponse
        let body: Data?
        
        var status: Status {
            Status(rawValue: response.statusCode)
        }
        
        var message: String {
            HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        }
        
        var headers: [AnyHashable: Any] { response.allHeaderFields }
    }
    
}
