//
//  HTTP+Method.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation

extension HTTP{
    struct Method: Hashable {
        static let get = Method(rawValue: "GET")
        static let post = Method(rawValue: "POST")
        static let put = Method(rawValue: "PUT")
        static let delete = Method(rawValue: "DELETE")
        
        public let rawValue: String
    }
}
