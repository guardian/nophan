//
//  Networking.swift
//
//
//  Created by Usman Nazir on 20/05/2024.
//

import Foundation

protocol Networking {
    var requestCache: Cache { get }
    func request(request: NophanRequest) async throws
    func retryFailedRequests()
}
