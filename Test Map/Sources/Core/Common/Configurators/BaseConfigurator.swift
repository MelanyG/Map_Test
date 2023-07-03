//
//  BaseConfigurator.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

class BaseConfigurator: Configurable, NavigationControllerEmbedding {
    var isFirstInFlow: Bool = false
    
    func generateController() -> UIViewController {
        return UIViewController()
    }
}
