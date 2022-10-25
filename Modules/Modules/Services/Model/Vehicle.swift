//
//  Vehicle.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 21.10.22.
//

import Foundation

public enum MapItemDecodingError: Error {
    case UnknownMapItemType
}

struct MapItemsResponseData: Decodable {
    let vehiclesData: [MapItem]
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case vehiclesData = "data"
        case statusCode
    }
}

public struct MapItem: Decodable {
    public enum ItemType {
        struct KeyConstants {
            static let vehicle = "vehicle"
        }
        
        case vehicle(attributes: VehicleAttributes)
        
        init<K>(type: String,
                from container: KeyedDecodingContainer<K>,
                attributesKey key: K) throws {
            switch type {
            case KeyConstants.vehicle:
                let attributes = try container.decode(VehicleAttributes.self,
                                                      forKey: key)
                self = .vehicle(attributes: attributes)
            default:
                throw MapItemDecodingError.UnknownMapItemType
            }
        }
    }
    
    public let id: String
    public let type: ItemType
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case attributes
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self,
                               forKey: .id)
        
        let itemType = try values.decode(String.self,
                                         forKey: .type)
        type = try ItemType(type: itemType,
                            from: values,
                            attributesKey: .attributes)
    }
}

public struct VehicleAttributes: Decodable {
    public enum VehicleType: String, Decodable {
        case eScooter = "escooter"
        case eBicycle = "ebicycle"
        case eMoped = "emoped"
    }
    
    public let type: VehicleType
    public let batteryLevel: Int
    public let latitude: Float
    public let longitude: Float
    public let maxSpeed: Int
    public let hasHelmetBox: Bool
    
    enum CodingKeys: String, CodingKey {
        case type = "vehicleType"
        case batteryLevel
        case latitude = "lat"
        case longitude = "lng"
        case maxSpeed
        case hasHelmetBox
    }
}
