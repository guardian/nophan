//
//  MockNetworkEngine.swift
//
//
//  Created by Usman Nazir on 20/05/2024.
//

import Foundation
@testable import Nophan

class MockNetworkEngine: Networking {
    
    var requestCache: Cache = MockCache()
    var shouldFail = false
    
    internal func request(request: NophanRequest) async throws {
        if shouldFail {
            requestCache.addRequestToQueue(request)
            throw NophanError.NetworkRequestError
        }
    }
    
    internal func retryFailedRequests() {
        guard !requestCache.isEmpty else { print("No requests to retry."); return }
        var requests = requestCache.getFailedRequests()
        while !requests.isEmpty {
            guard let task = requests.popLast() else { return }
            Task.detached(priority: .background) {
                do {
                    try await self.request(request: task)
                } catch {
                    print("Retry failed for request: \(task.parameters), error: \(error)")
                }
            }
        }
    }
}
