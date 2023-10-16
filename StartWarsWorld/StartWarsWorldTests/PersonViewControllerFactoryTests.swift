//
//  PersonViewControllerFactoryTests.swift
//  StartWarsWorldTests
//
//  Created by Amol Jagtap on 16/10/2023.
//

import XCTest
@testable import StartWarsWorld

final class PersonViewControllerFactoryTests: XCTestCase {
    func test_ViewControllerFactory_ReturnsPeopleVC() {
        let person = Person(name: "test", birth_year: "1990", gender: "Male", homeworld: "")
        let filmService = FilmNetworkService()
        let vc = PersonViewControllerFactory.makePersonDetailViewController(person: person, filmService: filmService)
        XCTAssertTrue(vc is PersonDetailViewController)
        XCTAssertEqual(vc.dataController?.person.name, "test")
    }

}
