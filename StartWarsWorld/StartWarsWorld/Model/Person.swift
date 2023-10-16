//
//  Person.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

struct Person: Codable {
    var name: String
    var birth_year: String
    var gender: String
    var homeworld: String
    var films: [String]?
}

extension Person: Identifiable, Hashable {
    var id: UUID {
        UUID()
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
}
