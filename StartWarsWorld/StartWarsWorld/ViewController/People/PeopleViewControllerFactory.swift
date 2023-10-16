//
//  PeopleViewControllerFactory.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

enum PeopleViewControllerFactory {

    static func makePeopleViewController() -> PeopleViewController {
        let peopleVC = UIStoryboard.main.instantiateViewController() as PeopleViewController
        return peopleVC
    }
}
