//
//  BaseConfiguratorContainingControllerType.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

class BaseConfiguratorContainingControllerType: BaseConfigurator {
    let controllerType: ControllerCreationable
    
    init(with type: ControllerCreationable) {
        controllerType = type
    }
}
