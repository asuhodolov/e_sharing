//
//  ScootersMapViewPresenter.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 12.10.22.
//

import Foundation
import Services
import CoreLocation

protocol ScootersMapViewPresenterInput {
    func showVehicles(from mapItems: [MapItem])
    func highlight(mapItem: MapItem)
    func setReloadButtonHidden(hidden: Bool)
}

final class ScootersMapViewPresenter {
    weak var view: ScootersMapViewControllerInput?
}

//MARK: - ScootersMapViewPresenterInput

extension ScootersMapViewPresenter: ScootersMapViewPresenterInput {
    func showVehicles(from mapItems: [MapItem]) {
        let vehicles = mapItems.compactMap { item -> VehicleViewModel? in
            guard case let .vehicle(vehicleAttributes) = item.type else { return nil }
            return VehicleViewModel(
                id: item.id,
                type: vehicleAttributes.type,
                batteryLevel: vehicleAttributes.batteryLevel,
                location: CLLocationCoordinate2DMake(vehicleAttributes.latitude,
                                                     vehicleAttributes.longitude))
            
        }
        
        view?.show(vehicles: vehicles)
    }
    
    func highlight(mapItem: MapItem) {
        view?.highlightMapItem(with: mapItem.id)
    }
    
    func setReloadButtonHidden(hidden: Bool) {
        view?.setReloadButtonHidden(hidden: hidden)
    }
}
