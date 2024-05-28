//
//  File.swift
//
//
//  Created by Usman Nazir on 28/05/2024.
//

import Foundation
import Qalam

/// A cache for managing failed network requests, storing them to disk and allowing retrieval for retry purposes.
internal class RequestCache: Cache {
    /// An array to store the queue of failed requests.
    private var failedTasksQueue = [NophanRequest]()
    
    /// The file URL where the failed requests queue is stored.
    private let fileURL: URL = getDocumentsDirectory()
    
    /// A dispatch queue for synchronizing access to the queue.
    private let queue = DispatchQueue(label: "com.nophan.requestCacheQueue")
    
    /// A boolean property indicating if the failed requests queue is empty.
    var isEmpty: Bool {
        queue.sync {
            failedTasksQueue.isEmpty
        }
    }
    
    /// Initializes a new instance of `RequestCache` and loads the queue from disk.
    init() {
        self.loadQueue()
    }
    
    /// Adds a failed request to the queue and saves the updated queue to disk.
    ///
    /// - Parameter request: The `NophanRequest` to add to the queue.
    func addRequestToQueue(_ request: NophanRequest) {
        queue.async(flags: .barrier) {
            self.failedTasksQueue.append(request)
            self.saveQueue()
        }
    }
    
    /// Retrieves and clears all failed requests from the queue.
    ///
    /// - Returns: An array of `NophanRequest` objects representing the failed requests.
    func getFailedRequests() -> [NophanRequest] {
        queue.sync {
            let failedRequests = failedTasksQueue
            failedTasksQueue = []
            saveQueue()
            return failedRequests
        }
    }
}

// MARK: - Disk utility functions
extension RequestCache {
    
    /// Returns the URL for the application's support directory where the failed requests queue is stored.
    ///
    /// - Returns: A `URL` pointing to the `nophan_failed_queue.json` file.
    private static func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("nophan_failed_queue.json")
        return path
    }
    
    /// Saves the failed requests queue to disk as a JSON file.
    private func saveQueue() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(failedTasksQueue)
            try data.write(to: fileURL)
        } catch {
            Log.console("Failed to sync failed requests to disk: \(error.localizedDescription)", .error, .nophan)
        }
    }
    
    /// Loads the failed requests queue from the JSON file on disk.
    private func loadQueue() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL)
            failedTasksQueue = try decoder.decode([NophanRequest].self, from: data)
        } catch {
            Log.console("Failed to load failed requests from disk: \(error.localizedDescription)", .error, .nophan)
        }
    }
}
