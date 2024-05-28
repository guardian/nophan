//
//  NophanMonitor.swift
//  
//
//  Created by Usman Nazir on 28/05/2024.
//

import Foundation

/// A struct that maintains an array of the last 15 NophanRequest objects.
internal class NophanMonitor: ObservableObject {
    
    /// Shared instance
    static let shared = NophanMonitor()
    
    /// An array to store the last 15 NophanRequest objects.
    @Published private(set) var events: [NophanRequest] = []

    /// Adds a new event to the array, ensuring only the last 15 events are kept.
    func addEvent(_ event: NophanRequest) {
        if events.count >= 15 {
            events.removeFirst()
        }
        events.append(event)
    }
}
