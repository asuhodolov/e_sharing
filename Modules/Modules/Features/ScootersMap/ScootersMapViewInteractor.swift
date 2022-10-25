//
//  ScootersMapViewInteractor.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 25.10.22.
//

import Foundation
import MapKit
import Services

protocol ScootersMapViewInteractorInput {
    func mapRegionUpdated(region: MKCoordinateRegion)
}

final class ScootersMapViewInteractor {
    private var visibleMapRegion: MKCoordinateRegion?
    private let vehiclesProvider: VehiclesProviderProtocol
    private let presenter: ScootersMapViewPresenterInput
    
    init(visibleMapRegion: MKCoordinateRegion? = nil,
         vehiclesProvider: VehiclesProviderProtocol,
         presenter: ScootersMapViewPresenterInput) {
        self.visibleMapRegion = visibleMapRegion
        self.vehiclesProvider = vehiclesProvider
        self.presenter = presenter
    }
}

//MARK: - ScootersMapViewInteractorInput

extension ScootersMapViewInteractor: ScootersMapViewInteractorInput {
    func mapRegionUpdated(region: MKCoordinateRegion) {
        
    }
}
