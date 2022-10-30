//
//  ScootersMapAssembly.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 12.10.22.
//

import Foundation
import Services
import UIKit

public enum ScootersMapAssembly {
    public struct Dependencies {
        let vehiclesProvider: VehiclesProviderProtocol

        public init(vehiclesProvider: VehiclesProviderProtocol) {
            self.vehiclesProvider = vehiclesProvider
        }
    }
    
    public static func assemble(dependencies: Dependencies) -> UIViewController {
        let presenter = ScootersMapViewPresenter()
        let interactor = ScootersMapViewInteractor(
            vehiclesProvider: dependencies.vehiclesProvider,
            presenter: presenter)
        let viewController = ScootersMapViewController(interactor: interactor)
        presenter.view = viewController
        interactor.presentModalView = viewController.viewModalPresenter
        interactor.dismissModalView = viewController.viewModalDismisser
        return viewController
    }
}
