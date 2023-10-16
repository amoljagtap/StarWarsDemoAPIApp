//
//  Film.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

struct Film: Codable {
    var title: String
    var opening_crawl: String
    var release_date: String
    var characters: [String]
}

extension Film: Identifiable, Hashable {
    var id: UUID {
        UUID()
    }
    
    static func ==(lhs: Film, rhs: Film) -> Bool {
        return lhs.id == rhs.id
    }
}

