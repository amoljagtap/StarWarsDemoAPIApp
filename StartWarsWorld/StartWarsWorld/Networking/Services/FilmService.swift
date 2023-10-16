//
//  FilmService.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

protocol FilmService : BaseService {
    var filmRequest: HTTP.Request { get }
        
    func getFilms(_ urls: [URL]) async throws -> [URL: Film?] 
}

struct FilmNetworkService: FilmService {
    var filmRequest: HTTP.Request {
        HTTP.Request(endpoint: .films)
    }
    
    func getFilms(_ urls: [URL]) async throws -> [URL: Film?] {
        return try await withThrowingTaskGroup(of: (URL, Film?).self) { group in
            for url in urls {
                group.addTask{
                    let request = Request<Film>(underlyingRequest: .init(endpoint: .init(url: url)))
                    let result = await networkFacade.execute(request: request)
                    switch result {
                    case .success(let film):
                        return (url, film)
                    case .failure(_):
                        return (url, nil)
                    }
                    
                }
            }
            var films = [URL: Film?]()
            for try await (url, film) in group {
                films[url] = film
            }
            return films
        }
    }
}
