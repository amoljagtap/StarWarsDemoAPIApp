//
//  PeopleDataController.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

struct Loading: Hashable, Identifiable {
    let id = UUID()
}

class PeopleDataController: ApplicationDataController {
    
    enum Row: Hashable {
        case people(Person)
        case loading(Loading)
    }

    private(set) var persons: [Row] = []
    
    private(set) var people: People?
    
    private(set) var loadingRow: [Row] = [.loading(Loading())]
    
    private var totalPersons: [Person] = []
    
    typealias Handler = (State) -> Void
    
    var canFetchMoreData: Bool {
        guard let people = people else {
            return true
        }
        return totalPersons.count < people.count
    }
    
    enum State {
        case loading
        case presenting([Row])
        case failed(String)
    }
        
    let peopleService: PeopleService
    
    private var requestInProgress = false
    
    init(peopleService: PeopleService) {
        self.peopleService = peopleService
    }
    
    func person(at index: Int) -> Person? {
        guard index < totalPersons.count else {
           return nil
        }
        return totalPersons[index]
    }
        
    func load(then handler: @escaping Handler) {
        if requestInProgress || !canFetchMoreData {
            return
        }
        Task {
            do {
                requestInProgress = true
                let people = try await peopleService.getPeople(next: people?.next)
                self.people = people
                persons = people.results.map { .people($0) }
                totalPersons.append(contentsOf: people.results)
                requestInProgress = false
                handler(.presenting(persons))
            } catch {
                handler(.failed("Failed to fetch the data. Please try again later."))
            }
        }
    }
}
