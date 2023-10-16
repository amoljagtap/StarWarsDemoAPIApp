//
//  People.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

struct People: Codable {
    var next: String
    var count: Int
    var results: [Person]
}

extension People: Hashable, Identifiable {
    var id: UUID {
        UUID()
    }
    
    static func ==(lhs: People, rhs: People) -> Bool {
        return lhs.id == rhs.id
    }
}


