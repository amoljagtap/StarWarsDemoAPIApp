//
//  PeopleService.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

protocol PeopleService: BaseService {
    
    var peopleRequest: Request<People> { get }
    
    func getPeople(next: String?) async throws -> People
}

extension PeopleService {
    var peopleRequest: Request<People> {
        Request(underlyingRequest: HTTP.Request(endpoint: .people))
    }
}

struct PeopleNetworkService: PeopleService {
    
    func getPeople(next: String?) async throws -> People {
        var request = peopleRequest
        if let next = next,
           let url = URL(string: next) {
            request = Request(underlyingRequest: HTTP.Request(endpoint: .init(url: url)))
        }
        let result = await networkFacade.execute(request: request)
        switch result {
        case .success(let people):
            return people
        case .failure(let error):
            throw error
        }
    }
}
