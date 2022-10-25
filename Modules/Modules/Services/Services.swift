//
//  Services.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 21.10.22.
//

import Foundation

public final class Services {
    public lazy var vehiclesProvider: VehiclesProviderProtocol = VehiclesProvider()
    
    public init() {}
}
