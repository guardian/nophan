//
//  Event.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import Foundation

/// `NophanEventRepresentable` defines a protocol for events that can be tracked within the FPA system.
/// Conforming types must provide a name and parameters for the event.
public protocol NophanEventRepresentable {
    /// The name of the event.
    var name: String { get set }
    
    /// A dictionary of parameters associated with the event.
    var parameters: [String: Any] { get set }
}

/// Example of conforming to the `NophanEventRepresentable` protocol:
/// ```
/// struct ExampleEvent: NophanEventRepresentable {
///     var name: String
///     var parameters: [String: Any]
/// }
///
/// // Usage:
/// let event = ExampleEvent(name: "UserSignUp", parameters: ["method": "email"])
/// Nophan.shared.trackEvent(event)
/// ```
