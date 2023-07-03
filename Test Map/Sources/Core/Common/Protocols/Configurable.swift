//
//  Configurable.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

protocol Configurable: AnyObject {
    var controller: UIViewController { get }
    
    func generateController() -> UIViewController
}

extension Configurable {
    var controller: UIViewController {
        return preparedController()
    }
    
    private func preparedController() -> UIViewController {
        let createdController = generateController()

        guard let canBeEmbeddedItem = self as? NavigationControllerEmbedding, canBeEmbeddedItem.isFirstInFlow == true else {
            return createdController
        }
        
        let navigationController = BaseNavigationViewController(rootViewController: createdController)
        navigationController.navigationBar.isHidden = true
        
        return navigationController
    }
}
