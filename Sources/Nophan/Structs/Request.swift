//
//  Request.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import Foundation

internal struct NophanRequest {
    var endpointUrl: URL
    var parameters: [String : Any]
    var httpMethod: String {
        return "POST"
    }
}
