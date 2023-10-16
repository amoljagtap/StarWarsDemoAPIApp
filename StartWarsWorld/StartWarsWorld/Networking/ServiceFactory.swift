//
//  ServiceFactory.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

protocol ServiceCreatable {
    func getPeopleService() -> PeopleService
    func getFilmService() -> FilmService
}

class ServiceFactory: ServiceCreatable {

    func getPeopleService() -> PeopleService {
        return PeopleNetworkService()
    }
    
    func getFilmService() -> FilmService {
        return FilmNetworkService()
    }
}
