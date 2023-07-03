//
//  PlainModelFillable.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import Foundation

protocol PlainModel { }

protocol PlainModelFillable {
    func fill(with model: PlainModel)
}
