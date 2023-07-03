//
//  MapsListModel.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import Foundation

protocol MapsListModellable {
    var countries: [CountryRepresentation] { get }
    func loadMap(index: IndexPath)
}

class MapsListModel: MapsListModellable {
    private(set) var countries: [CountryRepresentation] = []
    private var parser: CountryParser?
    private let databaseManager: DatabaseManager = DatabaseManager.shared
    let pendingOperations = PendingOperations()

    init() {
        startParse()
    }
    
    init(regions: [CountryRepresentation]) {
        countries = regions
    }
    
    func startParse() {
        if let url = Bundle.main.url(forResource: "regions", withExtension: "xml") {
            do {
                let data = try Data(contentsOf: url)
                parser = CountryParser(data: data)
                if parser?.parse() == true {
                    databaseManager.countries = parser?.country?.regions ?? []
                    countries = databaseManager.countries
                } else {
                    print("\n---> parser error: \(parser?.parserError as Optional)")
                }
            } catch {
                print("\n---> data error: \(error)")
            }
        }
    }
    
    func loadMap(index: IndexPath) {
        let country = countries[index.row]
        
        var prefix = getPrefix(from: country)
        prefix = prefix.isEmpty ? prefix : prefix + "_"
        var sufix = getSufix(from: country)
        sufix = sufix.isEmpty ? sufix : "_" + sufix

        var fileName = "https://download.osmand.net/download.php?standard=yes&file=" + prefix + country.name.capitalized + sufix + "_2.obf.zip"
        if let url = URL(string: fileName) {
            country.url = url
        }
        startDownload(for: country, at: index)
    }
    
    func getPrefix(from country: CountryRepresentation) -> String {
        if let prefix = country.prefix {
            return prefix
        }
        if let parent = country.parent {
            return getPrefix(from: parent)
        }
        return ""
    }
    
    func getSufix(from country: CountryRepresentation) -> String {
        if let prefix = country.suffix {
            return prefix
        }
        if let parent = country.parent {
            return getSufix(from: parent)
        }
        return ""
    }
    
    func startDownload(for country: CountryRepresentation, at indexPath: IndexPath) {
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
          pendingOperations.downloadsInProgress[indexPath]?.cancel()
          pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        return
      }
      
        let downloader = MapDownloader(country, indexPath: indexPath)
      downloader.completionBlock = {
        if downloader.isCancelled {
            self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
          return
        }
        
        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
      }
      pendingOperations.downloadsInProgress[indexPath] = downloader
      pendingOperations.downloadQueue.addOperation(downloader)
    }
}
