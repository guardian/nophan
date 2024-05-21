//
//  Configuration.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import Foundation
import UIKit

/// `NophanConfiguration` is a struct that holds the configuration details for the FPA system,
/// including the endpoint URL, user ID, app version, build number, iOS version, device model,
/// bundle ID, locale, operating system, and timestamp.
public struct NophanConfiguration {
    /// The endpoint URL for the FPA system.
    let endpointUrl: URL
    
    /// The user ID associated with the configuration.
    var userId: String?
    
    /// The version of the app.
    let appVersion: String
    
    /// The build number of the app.
    let build: String
    
    /// The version of iOS running on the device.
    let iosVersion: String
    
    /// The model of the device.
    let deviceModel: String
    
    /// The bundle identifier of the app.
    let bundleId: String
    
    /// The current locale identifier.
    let locale: String
    
    /// The operating system name.
    let operatingSystem: String
    
    /// Initializes a new instance of `NophanConfiguration`.
    ///
    /// - Parameters:
    ///   - endpointUrl: The endpoint URL for the FPA system.
    ///   - userId: The user ID associated with the configuration. Defaults to `nil`.
    ///
    /// Example usage:
    /// ```
    /// let config = NophanConfiguration(endpointUrl: URL(string: "https://api.example.com")!)
    /// print(config.appVersion) // Prints the app version
    /// ```
    public init(endpointUrl: URL, userId: String? = nil) {
        self.endpointUrl = endpointUrl
        self.userId = userId
        self.appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        self.build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        self.iosVersion = UIDevice.current.systemVersion
        self.deviceModel = UIDevice.current.name
        self.bundleId = Bundle.main.bundleIdentifier!
        self.locale = Locale.current.identifier
        self.operatingSystem = UIDevice.current.systemName
    }
}
