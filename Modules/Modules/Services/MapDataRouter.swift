//
//  MapDataRouter.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 24.10.22.
//

import Foundation
import Alamofire

enum MapDataRouter: URLRequestConvertible {
    case mapItems
    
    struct Constants {
        static let apiBaseUrlString = "https://api.jsonstorage.net/v1"
        static let apiKey = "9ef7d5b3-21c7-4a78-a92b-91efef42cabb"
    }
    
    var baseURL: URL {
        URL(string: Constants.apiBaseUrlString)!
    }
    
    var path: String {
        switch self {
        case .mapItems:
            return "json/9ec3a017-1c9d-47aa-8c38-ead2bfa9b339/c284fd9a-c94e-4bfa-8f26-3a04ddf15b47"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .mapItems:
            return .get
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .mapItems:
            return ["apiKey": Constants.apiKey]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        switch method {
        case .get:
            request = try URLEncodedFormParameterEncoder().encode(parameters,
                                                                  into: request)
        case .post:
            request = try JSONParameterEncoder().encode(parameters,
                                                        into: request)
        default:
            break
        }
    
        return request
    }
}
