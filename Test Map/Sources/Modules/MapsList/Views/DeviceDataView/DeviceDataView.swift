//
//  DeviceDataView.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

class DeviceDataView: NibDesignable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceDataLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    func setUpData(progress: Float, freeSpace: String) {
        progressBar.progress = progress
        progressBar.setProgress(progressBar.progress, animated: true)
        deviceDataLabel.text = freeSpace
    }
}
