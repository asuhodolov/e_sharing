//
//  VehicleAnnotation.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 27.10.22.
//

import Foundation
import MapKit
import Services

final class VehicleAnnotation: MKPointAnnotation, Identifiable {
    var id: MapItemId
    
    init(id: MapItemId) {
        self.id = id
        super.init()
    }
}
