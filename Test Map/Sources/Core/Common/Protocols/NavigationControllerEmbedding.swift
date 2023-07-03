//
//  NavigationControllerEmbedding.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import Foundation

protocol NavigationControllerEmbedding: AnyObject {
    var isFirstInFlow: Bool { get set }
}

extension NavigationControllerEmbedding {
    var isFirstInFlow: Bool {
        return false
    }
}
