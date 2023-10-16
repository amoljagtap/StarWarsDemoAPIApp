//
//  PersonViewControllerFactory.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

enum PersonViewControllerFactory {

    static func makePersonDetailViewController(person: Person,
                                               filmService: FilmService) -> PersonDetailViewController {
        let personVC = UIStoryboard.main.instantiateViewController() as PersonDetailViewController
        personVC.dataController = PersonDataController(person: person, filmService: filmService)
        return personVC
    }
}
