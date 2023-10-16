//
//  ApplicationDataController.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

class ApplicationDataController: NSObject {
    
    static let shared = ApplicationDataController()

    let serviceFactory: ServiceCreatable
    
    init(serviceFactory: ServiceCreatable = ServiceFactory()) {
        self.serviceFactory = serviceFactory
    }
}
