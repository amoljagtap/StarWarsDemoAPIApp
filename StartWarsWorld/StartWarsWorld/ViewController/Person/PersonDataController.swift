//
//  PersonDataController.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation


struct PersonDataController {
    
    enum State {
        case loading
        case presenting([Film])
        case failed(String)
    }

    let person: Person
    let filmService: FilmService
    
    init(person: Person, filmService: FilmService) {
        self.person = person
        self.filmService = filmService
    }
    
    func loadFilms(then handler: @escaping (State) -> ()) {
        guard let films = person.films else {
            return
        }
        Task {
            let urls = films.compactMap { URL(string: $0)}
            let result = try? await filmService.getFilms(urls)
            let films = result?.compactMap { _, film in
                return film
            } ?? []
            handler(.presenting(films))
        }
    }
}

//    var films = [Film(title: "FilmABC",
//                      opening_crawl: "FilmA Desc",
//                      release_date: "20 March 2020",
//                      characters: []),
//                 Film(title: "FilmXYZ",
//                      opening_crawl: "FilmA Desc",
//                      release_date: "20 March 2020",
//                      characters: []),
//                 Film(title: "FilmDEF",
//                      opening_crawl: "FilmA Desc",
//                      release_date: "20 March 2020",
//                      characters: []),
//                 Film(title: "FilmA",
//                      opening_crawl: "FilmA Desc",
//                      release_date: "20 March 2020",
//                      characters: []),
//                 Film(title: "FilmB",
//                      opening_crawl: "FilmA Desc",
//                      release_date: "20 March 2020",
//                      characters: []),
//                 Film(title: "FilmC",
//                      opening_crawl: "FilmA Desc",
//                      release_date: "20 March 2020",
//                      characters: []),
//                 Film(title: "FilmD",
//                      opening_crawl: "FilmA Desc",
//                      release_date: "20 March 2020",
//                      characters: []),
//                 Film(title: "FilmE",
//                      opening_crawl: "FilmA Desc",
//                      release_date: "20 March 2020",
//                      characters: [])]
    
