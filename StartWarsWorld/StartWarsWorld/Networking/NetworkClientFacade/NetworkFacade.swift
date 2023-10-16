//
//  NetworkFacade.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation

protocol HTTPRequestDispatcher {
    func execute(request: HTTP.Request) async -> HTTPResult
    func execute<Response>(request: Request<Response>) async -> Result<Response, Error>
}

struct NetworkFacade: HTTPRequestDispatcher {
    
    
    static let shared = NetworkFacade()
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession._defaultSession) {
        self.session = session
    }
        
    func execute(request: HTTP.Request) async -> HTTPResult {
        guard let urlRequest = request.makeRequest() else {
            return .failure(.invalidRequest)
        }
        
        do {
            let (data, urlResponse) = try await session.data(for: urlRequest, delegate: nil)
            guard let response = urlResponse as? HTTPURLResponse else {
                return .failure(.init(code: .invalidResponse,
                                            request: request,
                                            response: nil,
                                            underlyingError: nil))
            }
            if (200...299).contains(response.statusCode) {
                let response = HTTP.Response(request: request, response: response, body: data)
                return .success(response)
            } else if (400...499).contains(response.statusCode) {
                return .failure(.init(code: .clientError,
                                            request: request,
                                            response: nil,
                                            underlyingError: nil))
            } else if (500...599).contains(response.statusCode) {
                return .failure(.init(code: .serverError,
                                            request: request,
                                            response: nil,
                                            underlyingError: nil))
            } else {
                return .failure(.init(code: .invalidResponse,
                                            request: request,
                                            response: nil,
                                            underlyingError: nil))
            }
        } catch let error {
            return .failure(.init(code: .unknown,
                                        request: request,
                                        response: nil,
                                        underlyingError: error))
        }
    }
    
    func execute<Response>(request: Request<Response>) async -> Result<Response, Error> {
        let result = await execute(request: request.underlyingRequest)
        switch result {
        case .success(let response):
            do {
                let response = try request.decode(response)
                return .success(response)
            } catch {
                return .failure(ParsingError.failedDecodeModel)
            }
        case .failure(let error):
            return Result.failure(error)
        }
    }
}


protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    
    static var _defaultSession: URLSession{
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.waitsForConnectivity = true
        sessionConfiguration.allowsConstrainedNetworkAccess = true
        return URLSession(configuration: sessionConfiguration)
    }
}
