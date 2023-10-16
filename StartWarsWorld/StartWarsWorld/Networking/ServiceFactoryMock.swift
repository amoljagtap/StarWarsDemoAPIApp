//
//  ServiceFactoryMock.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

struct ServiceFactoryMock: ServiceCreatable {
    
    func getPeopleService() -> PeopleService {
        return PeopleNetworkServiceMock()
    }
    
    func getFilmService() -> FilmService {
        fatalError("mock service not implemented")
    }
}
