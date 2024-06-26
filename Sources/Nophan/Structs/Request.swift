//
//  Request.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import Foundation

internal struct NophanRequest: Codable, Identifiable {
    var id = UUID()
    var endpointUrl: URL
    var parameters: [String : Any]
    var httpMethod: String {
        return "POST"
    }
    
    var deviceTimestamp: Double {
        return (parameters["device_timestamp"] as? Double) ?? 0.0
    }
    
    enum CodingKeys: String, CodingKey {
        case endpointUrl, parameters, httpMethod
    }
    
    init(endpointUrl: URL, parameters: [String: Any]) {
        self.endpointUrl = endpointUrl
        self.parameters = parameters
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        endpointUrl = try values.decode(URL.self, forKey: .endpointUrl)
        let data = try values.decode(Data.self, forKey: .parameters)
        parameters = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endpointUrl, forKey: .endpointUrl)
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
        try container.encode(data, forKey: .parameters)
    }
}
