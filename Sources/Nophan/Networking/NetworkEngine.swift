//
//  NetworkEngine.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import Foundation

internal class NetworkEngine: Networking {
    
    internal var failedTasksQueue = [NophanRequest]()
    private var isRetrying = false
    
    /// Makes the request
    internal func request(request: NophanRequest) async throws {
        var urlRequest = URLRequest(url: request.endpointUrl)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.timeoutInterval = 30.0
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.parameters)
            URLSession(configuration: .default).dataTask(with: urlRequest)
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
                throw NophanError.NetworkRequestError
            }
            retryFailedRequests()
        } catch {
            addToRetryQueue(request: request)
            throw NophanError.NetworkRequestError
        }
    }
    
    private func addToRetryQueue(request: NophanRequest) {
        failedTasksQueue.append(request)
    }
    
    internal func retryFailedRequests() {
        guard !isRetrying, !failedTasksQueue.isEmpty else { print("No requests to retry."); return }
        isRetrying = true
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
        isRetrying = false
    }
}
