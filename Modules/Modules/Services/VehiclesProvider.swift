//
//  EScootersProvider.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 21.10.22.
//

import Foundation
import Alamofire

public protocol VehiclesProviderProtocol {
    func retrieveMapItems(of type: MapItem.ItemType) async throws -> [MapItem]
}

final public class VehiclesProvider: VehiclesProviderProtocol {
    public func retrieveMapItems(of type: MapItem.ItemType) async throws -> [MapItem] {
        let request = AF.request(MapDataRouter.mapItems)
        let responseValue = try await request.serializingDecodable(MapItemsResponseData.self).value
        return responseValue.vehiclesData
    }
}
