//
//  NavigationBar.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

@objc protocol NavigationBarDelegate: AnyObject {
    func leftActionSelected(with owner: Any)
}

struct TitleContent {
    let title: String
}

class NavigationBar: NibDesignable {
    @IBInspectable var isLeftButtonDisabled: Bool = false {
        didSet {
            leftButton.isHidden = isLeftButtonDisabled
            leftButton.isEnabled = !isLeftButtonDisabled
        }
    }
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBOutlet weak var delegate: NavigationBarDelegate?

    @IBOutlet weak fileprivate var titleLabel: UILabel!
    
    @IBOutlet weak fileprivate var leftButton: UIButton!
    
    @IBAction func backSelected(_ sender: UIButton) {
        delegate?.leftActionSelected(with: self)
    }
    
    func fillTitle(content: String) {
        title = content
    }
}
