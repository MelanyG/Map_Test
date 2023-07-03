//
//  Presenter.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import Foundation

protocol Presenter: AnyObject {
    func viewLoaded()
    
    func viewWillAppear()
    func viewDidAppear()

    func viewWillDisappear()

}

extension Presenter {
    func viewLoaded() { }
    
    func viewWillAppear() { }
    func viewDidAppear() { }

    func viewWillDisappear() { }
}
