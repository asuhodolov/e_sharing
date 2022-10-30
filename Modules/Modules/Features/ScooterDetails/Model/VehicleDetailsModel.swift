//
//  VehicleDetailsModel.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 28.10.22.
//

import Foundation
import Services

struct VehicleDetails {
    let id: MapItemId
    let type: VehicleAttributes.VehicleType
    let batteryLevel: Int
    let hasHelmetBox: Bool
    let maxSpeed: Int
    
    init(id: MapItemId,
         vehicleAttributes: VehicleAttributes) {
        self.id = id
        self.type = vehicleAttributes.type
        self.batteryLevel = vehicleAttributes.batteryLevel
        self.hasHelmetBox = vehicleAttributes.hasHelmetBox
        self.maxSpeed = vehicleAttributes.maxSpeed
    }
}
