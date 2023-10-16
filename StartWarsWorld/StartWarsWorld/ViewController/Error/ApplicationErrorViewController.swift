//
//  ApplicationErrorViewController.swift
//  StartWarsWorld
//
//  Created by Amol Jagtap on 16/10/2023.
//

import UIKit

class ApplicationErrorViewController: UIViewController {

    @IBOutlet var retryButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    
    var retryHandler: (() -> Void)?
    
    func set(errorMessage: String, retryHandler: (() -> Void)? = nil) {
        messageLabel.text = errorMessage
        self.retryHandler = retryHandler
    }

    @IBAction func retryButtonAction(_ sender: Any) {
        retryHandler?()
    }
}
