//
//  MockNetworkEngine.swift
//
//
//  Created by Usman Nazir on 20/05/2024.
//

import Foundation
@testable import Nophan

class MockNetworkEngine: Networking {
    
    var failedTasksQueue: [NophanRequest] = []
    
    var shouldFail = false
    
    internal func request(request: NophanRequest) async throws {
        if shouldFail {
            failedTasksQueue.append(request)
            throw NophanError.NetworkRequestError
        }
    }
    
    internal func retryFailedRequests() {
        guard !failedTasksQueue.isEmpty else { print("No requests to retry."); return }
        while !failedTasksQueue.isEmpty {
            guard let task = failedTasksQueue.popLast() else { return }
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
