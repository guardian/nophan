//
//  Cache.swift
//
//
//  Created by Usman Nazir on 28/05/2024.
//

import Foundation

/// A protocol that defines the interface for a cache that stores and manages failed network requests.
protocol Cache {
    
    /// A boolean property indicating if the cache is empty.
    var isEmpty: Bool { get }
    
    /// Adds a failed request to the cache.
    ///
    /// - Parameter request: The `NophanRequest` to add to the cache.
    func addRequestToQueue(_ request: NophanRequest)
    
    /// Retrieves and clears all failed requests from the cache.
    ///
    /// - Returns: An array of `NophanRequest` objects representing the failed requests.
    func getFailedRequests() -> [NophanRequest]
}
