//
//  PeopleDataControllerTests.swift
//  StartWarsWorldTests
//
//  Created by Amol Jagtap on 16/10/2023.
//

import XCTest
@testable import StartWarsWorld

final class PeopleDataControllerTests: XCTestCase {
    
    struct PeopleServiceMock: PeopleService {
        func getPeople(next: String?) async throws -> People {
            throw NSError(domain: "test", code: 1)
        }
    }
    
    var mockServicefactory = ServiceFactoryMock()
    
    var sut: PeopleDataController!
    
    override func setUp() {
        super.setUp()
        sut = PeopleDataController(peopleService: mockServicefactory.getPeopleService())
    }

    func test_PersonAtIndex_WithEmptyArray_ReturnNilObject() {
        XCTAssertNil(sut.person(at: 0))
    }

    func test_PeoplServiceLoadData_WithNoError_ReturnNonNilObject() {
        sut.load { _ in
            XCTAssertNil(self.sut.person(at: 0))
            XCTAssertEqual(self.sut.people?.results[0].name, "Test Test")
        }
    }
    
    func test_PeoplServiceLoadData_WithError_ReturnNilObject() {
        sut = PeopleDataController(peopleService: PeopleServiceMock())
        sut.load { state in
            switch state {
            case .failed(let message):
                XCTAssertEqual(message, "Failed to fetch the data. Please try again later.")
                XCTAssertNil(self.sut.person(at: 0))
            default:
                XCTFail("not expected")
            }
            
        }
    }
    
    func test_CanFetchMoreData_ReturnsFalseWhenNoMoreRecordsToFetch() {
        sut.load { state in
            XCTAssertFalse(self.sut.canFetchMoreData)
        }
    }
}
