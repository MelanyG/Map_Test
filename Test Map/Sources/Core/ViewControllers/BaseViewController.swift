//
//  BaseViewController.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

class BaseViewController: UIViewController,  ViewController {
    var presenter: Presenter!
    @IBOutlet weak var navigationBar: NavigationBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavigationBarUI()
        
        guard presenter != nil else {
            return
        }
        
        presenter.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard presenter != nil else {
            return
        }
        
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard presenter != nil else {
            return
        }
        
        presenter.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard presenter != nil else {
            return
        }
        
        presenter.viewWillDisappear()
    }
    
    private func updateNavigationBarUI() {
        let hasItemsInsStack = navigationController?.viewControllers.count ?? 1 > 1
        navigationBar?.isLeftButtonDisabled = !hasItemsInsStack
    }
}
