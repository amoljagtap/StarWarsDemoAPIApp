//
//  HTTP+Endpoint.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation

enum HTTP {}

extension HTTP {
    struct Endpoint {
        
        private let scheme = "https"
        private let host = "swapi.dev"
        
        static let people = Endpoint(path: .people)
        
        static let films = Endpoint(path: .films)
        
        fileprivate var underlyingURL: URL?
        
        let path: Path
        
        struct Path: ExpressibleByStringLiteral {
            var value: String
                        
            static let films: Path = "/api/films/"
            static let people: Path = "/api/people/"
            
            init(stringLiteral value: String) {
                self.value = value
            }
        }
    }
}

extension HTTP.Endpoint {
    
    init(url: URL) {
        self.init()
        self.underlyingURL = url
    }
    
    init() {
        self.init(path:"")
    }
    
    var url: URL {
        guard let url = underlyingURL,
              isValidDomainURL(url) else {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path.value
            guard let url = components.url else {
                fatalError("Failed to create an URL")
            }
            return url
        }
        return url
    }
    
    private func isValidDomainURL(_ url: URL) -> Bool {
        guard let _host = url.host(percentEncoded: true),
              let _scheme = url.scheme else {
            return false
        }
        return _host == host && _scheme == scheme
    }
}
