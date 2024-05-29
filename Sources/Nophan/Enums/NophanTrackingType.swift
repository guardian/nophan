//
//  TrackingType.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import Foundation

/// `TrackingType` defines the different types of tracking that can be performed within the FPA system.
///
/// - `Configuration`: Represents the tracking of configuration data.
/// - `User`: Represents the tracking of user data.
/// - `Event`: Represents the tracking of event data.
enum TrackingType: String {
    case Configuration
    case User
    case Event
    case Consent
    
    /// Provides the string value associated with each `TrackingType` case for use in parameters.
    ///
    /// - Returns: A `String` representing the parameter value for the tracking type.
    ///
    /// Example usage:
    /// ```swift
    /// let type = TrackingType.Event
    /// print(type.parameterValue) // Outputs: "event"
    /// ```
    var parameterValue: String {
        switch self {
        case .Configuration:
            return "configuration"
        case .User:
            return "user"
        case .Event:
            return "event"
        case .Consent:
            return "consent"
        }
    }
}
