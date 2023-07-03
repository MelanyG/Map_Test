//
//  MapsListMainConfigurator.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//


import UIKit

class MapListMainConfigurator: BaseConfiguratorContainingControllerType {
    private let type: ControllerCreationable

    init(isLoadedWithPrefilledControllers: Bool = true) {
        type = Controllers.mapList

        super.init(with: type)
        
        isFirstInFlow = true
    }
    
    override func generateController() -> UIViewController {
        let controllerType: Controllers = .mapList
        
        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? MapsListViewController else {
            return UIViewController()
        }
        let presenter = MapsListPresenter(model: MapsListModel())
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
//        presenter.onLogOut = { [weak viewController] in
//            DispatchQueue.main.async {
//                viewController?.navigationController?.popViewController(animated: true)
//            }
//        }
        
        return viewController
    }
}
