//
//  CountryCellPlainModel.swift
//  Test Map
//
//  Created by Melany Gulianovych on 03.07.2023.
//

import Foundation

struct CountryCellPlainModel: PlainModel {
    let name: String
    let isMap: Bool
    let progress: Float
    var state: MapState = .new

    weak var delegate: CountryCellDelegate?

    init(from dataStructure: CountryRepresentation, delegate: CountryCellDelegate? = nil) {
        self.delegate = delegate
        name = dataStructure.name.capitalized
        isMap = dataStructure.regions.isEmpty == true
        progress = dataStructure.progress
        state = dataStructure.state
    }
}
