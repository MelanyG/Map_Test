//
//  NibDesignable.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

open class NibDesignable: UIView {

    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    func setupNib() {
        let bundle = Bundle(for: type(of: self))
        guard let viewFromXib = bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? UIView else {
            print("Error! Can not initialize view from xib")
            return
        }
        viewFromXib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewFromXib.translatesAutoresizingMaskIntoConstraints = true
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }
}
