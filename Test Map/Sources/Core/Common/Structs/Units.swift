//
//  Units.swift
//  Test Map
//
//  Created by Melany Gulianovych on 03.07.2023.
//

import Foundation

struct Units {
    
    let bytes: Int64
    
    var kilobytes: Double {
        return Double(bytes) / 1_024
    }
    
    var megabytes: Double {
        return kilobytes / 1_024
    }
    
    var gigabytes: Double {
        return megabytes / 1_024
    }
    
    init(bytes: Int64) {
        self.bytes = bytes
    }
    
    func getReadableUnit() -> String {
        
        switch bytes {
        case 0..<1_024:
            return "\(bytes) bytes"
        case 1_024..<(1_024 * 1_024):
            return "\(String(format: "%.2f", kilobytes)) kb"
        case 1_024..<(1_024 * 1_024 * 1_024):
            return "\(String(format: "%.2f", megabytes)) mb"
        case (1_024 * 1_024 * 1_024)...Int64.max:
            return "\(String(format: "%.2f", gigabytes)) Gb"
        default:
            return "\(bytes) bytes"
        }
    }
}
