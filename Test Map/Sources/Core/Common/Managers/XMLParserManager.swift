//
//  XMLParser.swift
//  Test Map
//
//  Created by Melany Gulianovych on 03.07.2023.
//

import Foundation

private enum ParsingState: String {
    case regions_list = "regions_list"
    case region = "region"
    case type = "type"
    case continent = "continent"
    
    case name = "name"
    case inner_download_suffix = "inner_download_suffix"
    case inner_download_prefix = "inner_download_prefix"
    case poly_extract = "poly_extract"
    case map = "map"
    case srtm = "srtm"

}

class CountryParser: XMLParser {
    var country: CountryRepresentation?
    var currentCountry: CountryRepresentation?
    var currentRegion: CountryRepresentation?
    var embeddedRegion: CountryRepresentation?

    var closed = false
    
    override init(data: Data) {
        super.init(data: data)
        self.delegate = self
    }
}

extension CountryParser: XMLParserDelegate {
    
    // Called when opening tag (`<elementName>`) is found
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let item = CountryRepresentation(
            name: attributeDict["name"] ?? "",
            suffix: attributeDict["inner_download_suffix"],
            prefix: attributeDict["inner_download_prefix"],
            polyExtract: attributeDict["poly_extract"],
            map: attributeDict["map"] == "no" ? false : true)
        switch elementName {
        case ParsingState.regions_list.rawValue: break
        case ParsingState.region.rawValue:
            if attributeDict["type"] == ParsingState.continent.rawValue {
                country = item
            } else if attributeDict["name"] != nil && attributeDict["poly_extract"] != nil {
                currentCountry = item
            } else if attributeDict["type"] == ParsingState.srtm.rawValue || attributeDict["type"] == ParsingState.map.rawValue {
                embeddedRegion = item
            } else {
                currentRegion = item
            }
        default: break
        }
    }
    
    // Called when closing tag (`</elementName>`) is found
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if var embeddedRegion = embeddedRegion {
            embeddedRegion.parent = currentRegion
            currentRegion?.regions.append(embeddedRegion)
            self.embeddedRegion = nil
            return
        }
        if var currentRegion = currentRegion {
            currentRegion.parent = currentCountry
            currentCountry?.regions.append(currentRegion)
            self.currentRegion = nil
            return
        }
        if var currentCountry = currentCountry {
            currentCountry.parent = country
            country?.regions.append(currentCountry)
            self.currentCountry = nil
        }
    }
    
    // Called when a character sequence is found
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //...
    }
    
    // Called when a CDATA block is found
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard String(data: CDATABlock, encoding: .utf8) != nil else {
            print("CDATA contains non-textual data, ignored")
            return
        }
    }
}
