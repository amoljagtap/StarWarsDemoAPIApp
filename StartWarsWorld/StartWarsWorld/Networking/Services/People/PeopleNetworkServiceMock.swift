//
//  PeopleNetworkServiceMock.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation

struct PeopleNetworkServiceMock: PeopleService {
    func getPeople(next: String?) async throws -> People {
        return People(next: "",
                      count: 1,
                      results: [
                        Person(name: "Test Test", birth_year: "1990", gender: "Male", homeworld: "Test", films: [])
                      ])
    }
}
