//
//  EScootersProvider.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 21.10.22.
//

import Foundation
import Alamofire

public protocol VehiclesProviderProtocol {
    func retrieveMapItems() async throws -> [MapItem]
}

final public class VehiclesProvider: VehiclesProviderProtocol {
    public func retrieveMapItems() async throws -> [MapItem] {
        let request = AF.request(MapDataRouter.mapItems)
        let responseValue = try await request
            .validate(statusCode: 200..<300)
            .serializingDecodable(MapItemsResponseData.self)
            .value
        return responseValue.vehiclesData
    }
}
