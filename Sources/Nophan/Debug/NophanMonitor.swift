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

    /// Dispatch queue to modify events in a Thread Safe manner.
    let queue = DispatchQueue(label: "NophanMonitorEventsQueue")
    
    /// Adds a new event to the array, ensuring only the last 15 events are kept.
    func addEvent(_ event: NophanRequest) {
        queue.async(flags: .barrier) {
            if self.events.count >= 15 {
                self.events.removeFirst()
            }
            self.events.append(event)
        }
    }
}
