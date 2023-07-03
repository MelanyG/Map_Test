//
//  CountryRepresentation.swift
//  Test Map
//
//  Created by Melany Gulianovych on 03.07.2023.
//

import Foundation

enum MapState {
  case new, downloaded, failed, finished
}

class CountryRepresentation: NSObject {
    let id = UUID()
    var name: String
    var suffix: String?
    var prefix: String?
    var polyExtract: String?
    var map: Bool = true
    var state: MapState = .new
    var regions: [CountryRepresentation] = []
    var parent: CountryRepresentation? = nil
    
    var url: URL?
    var mapData: Data?
    @objc dynamic var progress: Float = 1

    init(name: String, suffix: String? = nil, prefix: String? = nil, polyExtract: String? = nil, map: Bool = true) {
        self.name = name
        self.suffix = suffix
        self.prefix = prefix
        self.polyExtract = polyExtract
        self.map = map
    }
}
