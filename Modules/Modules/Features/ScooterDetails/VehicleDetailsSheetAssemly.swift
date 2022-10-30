//
//  VehicleDetailsSheetAssemly.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 28.10.22.
//

import Foundation
import UIKit

enum VehicleDetailsSheetAssemly {
    static func assemble(with vehicleDetails: VehicleDetails) -> UIViewController {
        return VehicleDetailsView(vehicleDetails: vehicleDetails)
    }
}
