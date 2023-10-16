//
//  PeopleViewControllerFactoryTests.swift
//  StartWarsWorldTests
//
//  Created by Amol Jagtap on 16/10/2023.
//

import XCTest
@testable import StartWarsWorld

final class PeopleViewControllerFactoryTests: XCTestCase {

    func test_ViewControllerFactory_ReturnsPeopleVC() {
        let vc = PeopleViewControllerFactory.makePeopleViewController()
        XCTAssertTrue(vc is PeopleViewController)
    }

}
