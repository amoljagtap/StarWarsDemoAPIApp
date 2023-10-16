//
//  UIStoryboard+Helper.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

protocol ViewIdentifiable {
    static var identifier: String { get }
}

extension ViewIdentifiable where Self: UIViewController {
    static var identifier: String {
        String(describing: self)
    }
}

extension ViewIdentifiable where Self: UIView {
    static var identifier: String {
        String(describing: self)
    }
}

extension UIView: ViewIdentifiable {}

extension UIViewController: ViewIdentifiable { }

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: T.identifier)) as? T else {
            fatalError("Failed to initialise VC with identifier: \(T.identifier)")
        }
        return viewController
    }
    
    
}
