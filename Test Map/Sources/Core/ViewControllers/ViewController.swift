//
//  ViewController.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import UIKit

protocol ViewController: AnyObject {
    var presenter: Presenter! { get set }
}

protocol ViewControllerWithDefinedPresenter: ViewController {
    associatedtype CurrentPresenter
}

extension ViewControllerWithDefinedPresenter {
     var currentPresenter: CurrentPresenter {
        return presenter as! CurrentPresenter
    }
}

extension ViewController {
    func show(alertWithMessage message: String,
              andTitle title: String = Constants.Strings.empty) {
        guard let controller = self as? UIViewController else {
            return
        }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertAction.Style.default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
