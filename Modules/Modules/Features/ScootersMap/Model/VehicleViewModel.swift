//
//  VehicleViewModel.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 27.10.22.
//

import Foundation
import Services
import CoreLocation

struct VehicleViewModel {
    let id: MapItemId
    let type: VehicleAttributes.VehicleType
    let batteryLevel: Int
    let location: CLLocationCoordinate2D
}
