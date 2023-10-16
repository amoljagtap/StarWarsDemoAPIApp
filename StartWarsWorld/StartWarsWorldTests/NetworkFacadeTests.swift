//
//  NetworkFacadeTests.swift
//  StartWarsWorldTests
//
//  Created by Amol Jagtap on 16/10/2023.
//

import XCTest
@testable import StartWarsWorld

final class NetworkFacadeTests: XCTestCase {
    
    static var request: Request<People> {
        Request<People>(underlyingRequest: HTTP.Request(endpoint: .people))
    }
    
    class MockSession: URLSessionProtocol {
        static let people = People(next: "",
                                   count: 1,
                                   results: [
                                    Person(name: "Network Test", birth_year: "1990", gender: "Male", homeworld: "Test", films: [])
                                   ])
        
        var throwError = false
        
        func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
            if throwError {
                let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 500, httpVersion: "1.1", headerFields: nil)!
                return (Data(), response as URLResponse)
            } else {
                let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: "1.1", headerFields: nil)!
                return try! (Self.people.encoded(), response as URLResponse)
            }
        }
    }

    
    func test_ExecutePeopleRequest() async throws {
        let session = MockSession()
        let sut = NetworkFacade(session: session)
        let result = await sut.execute(request: NetworkFacadeTests.request)
        switch result {
        case .success(let people):
            XCTAssertEqual(people.results.first?.name, "Network Test")
            XCTAssertEqual(people.count, 1)
        case .failure(_):
            XCTFail("Error not expected")
        }
    }
    
    func test_ExecutePeopleRequest_ReturnsNetworkError() async throws {
        let request = Request<People>(underlyingRequest: HTTP.Request(endpoint: .people))
        let session = MockSession()
        session.throwError = true
        let sut = NetworkFacade(session: session)
        let result = await sut.execute(request: request)
        switch result {
        case .success(_):
            XCTFail("Network Error expected")
        case .failure(let error):
            if let error = error as? HTTP.NetworkError {
                XCTAssertEqual(error.code, .serverError)
            } else {
                XCTFail("Error not handled")
            }
        }
    }

}
