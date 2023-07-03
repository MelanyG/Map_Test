//
//  CountryTableViewCell.swift
//  Test Map
//
//  Created by Melany Gulianovych on 03.07.2023.
//

import UIKit

protocol CountryCellDelegate: AnyObject {
    func downloadSelected(selectedIn owner: Any)
}

class CountryTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var loadImage: UIImageView!
    fileprivate weak var delegate: CountryCellDelegate?

    @IBOutlet weak var progressView: UIProgressView!
    var model: CountryCellPlainModel!

    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        delegate?.downloadSelected(selectedIn: self)
        print("downloadButtonPressed")
    }
}

extension CountryTableViewCell: PlainModelFillable {
    func fill(with model: PlainModel) {
        guard let model = model as? CountryCellPlainModel else {
            return
        }
        
        delegate = model.delegate
        loadImage.isHidden = model.isMap == false
        nameLabel.text = model.name
        downloadButton.isHidden = model.isMap == false

        switch model.state {
        case .downloaded:
            progressView.isHidden = false
            loadImage.image = UIImage(named: "import")
            progressView.progress = model.progress
            
        case .finished:
            progressView.isHidden = true
            loadImage.image = UIImage(named: "ic_custom_dowload")
            progressView.progress = model.progress
            
        case .new, .failed:
            progressView.isHidden = true
            loadImage.image = UIImage(named: "importStart")
            progressView.progress = model.progress
        }
    }
}
