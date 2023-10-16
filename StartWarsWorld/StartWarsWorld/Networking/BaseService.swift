//
//  BaseService.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import Foundation

protocol BaseService {
    var networkFacade: NetworkFacade { get }
}

extension BaseService {
    var networkFacade: NetworkFacade {
        .shared
    }
}
