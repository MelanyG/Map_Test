//
//  MapListConfigurator.swift
//  Test Map
//
//  Created by Melany Gulianovych on 03.07.2023.
//

import UIKit

class MapListConfigurator: BaseConfigurator {
    var country: CountryRepresentation!
    override init() {}
    
    override func generateController() -> UIViewController {
        let controllerType: Controllers = .mapList
        
        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? MapsListViewController else {
            return UIViewController()
        }
        let presenter = MapsListPresenter(title: country.name.capitalized, model: MapsListModel(regions: country.regions))
        viewController.presenter = presenter
        presenter.controller = viewController
        
        presenter.countrySelected = { [weak viewController] country in
            let configurator = MapListConfigurator()
            configurator.country = country
            DispatchQueue.main.async {
                guard let navigationController = viewController?.navigationController else {
                    return
                }
                navigationController.pushViewController(configurator.controller, animated: true)
            }
        }
        
        presenter.backSelected = { [weak viewController] in
            DispatchQueue.main.async {
                viewController?.navigationController?.popViewController(animated: true)
            }
        }
        
        return viewController
    }
}
