//
//  ControllerCreationFabric.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

protocol ControllerCreationable {
    var controllerIdentifier: String { get }
    var storyboardIdentifier: String { get }
}

class ControllerCreationFabric {
    static let `default` = ControllerCreationFabric()
    
    var launchViewController: UIViewController? {
        let launchScreenName = "LaunchScreen"
        
        return UIStoryboard(name: launchScreenName, bundle: nil).instantiateInitialViewController()
    }
    
    func controller(for type: ControllerCreationable) -> UIViewController {
        let storyboard = UIStoryboard(name: type.storyboardIdentifier, bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: type.controllerIdentifier)
    }
}
