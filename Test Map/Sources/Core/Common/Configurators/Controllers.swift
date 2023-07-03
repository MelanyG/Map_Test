//
//  Controllers.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

enum Controllers {
    case mapList
}

extension Controllers: ControllerCreationable {
    var controllerIdentifier: String {
        switch self {
        case .mapList:
            return "MapsListViewController"
        }
    }
    
    var storyboardIdentifier: String {
        return "Main"
    }
}

extension Controllers {
    var configurator: Configurable {
        switch self {
        case .mapList:
            return MapListMainConfigurator()
        }
    }
}
