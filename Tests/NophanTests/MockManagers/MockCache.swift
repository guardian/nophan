//
//  File.swift
//
//
//  Created by Usman Nazir on 28/05/2024.
//

import Foundation
@testable import Nophan

class MockCache: Cache {
    
    private var failedTasksQueue = [NophanRequest]()
    var isEmpty: Bool { failedTasksQueue.isEmpty }
    
    func addRequestToQueue(_ request: NophanRequest) {
        failedTasksQueue.append(request)
    }
    
    func getFailedRequests() -> [NophanRequest] {
        let failedRequests = failedTasksQueue
        failedTasksQueue = []
        return failedRequests
    }
}
