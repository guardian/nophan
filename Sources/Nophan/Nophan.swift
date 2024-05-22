//
//  Nophan.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import Foundation
import Qalam

public typealias NophanUserId = String

/// `Nophan` is a singleton class responsible for managing the configuration
/// and networking engine of the Nophan system. It provides methods to set up the
/// configuration and user identifier.
public final class Nophan: Analytics {
    
    /// Shared instance of `Nophan`.
    public static var shared = Nophan()
    
#if DEBUG
    /// Indicates whether the manager is in debug mode. This is `true` in debug builds.
    public private(set) var debug: Bool = true
#else
    /// Indicates whether the manager is in debug mode. This is `false` in debug builds.
    public private(set) var debug: Bool = false
#endif
    
    /// The networking engine used by the manager.
    private let networkEngine: Networking
    
    // The Keychain manager used to fetch/save device id. This is initialised alongside the Configuration.
    private var keychain: Keychain? = nil
    
    /// The configuration for the FPA system. This is set through the `setup(configuration:)` method.
    public private(set) var configuration: NophanConfiguration?
    
    /// Initializes a new instance of `Nophan`.
    ///
    /// - Parameter networkEngine: The networking engine to be used by the manager. Defaults to `NetworkEngine()`.
    internal init(networkEngine: Networking = NetworkEngine()) {
        self.networkEngine = networkEngine
    }
    
    /// Sets up the configuration for the FPA system.
    /// Call this function as soon as the app cold-starts.
    ///
    /// - Parameter configuration: The configuration to be used.
    ///
    /// Example usage:
    /// ```
    /// let config = NophanConfiguration(endpointUrl: [your url here])
    /// Nophan.shared.setup(configuration: config)
    /// ```
    public func setup(configuration: NophanConfiguration) {
        self.configuration = configuration
        self.keychain = NophanKeychainManager(service: configuration.bundleId, account: "nophan_device_id")
        trackConfiguration()
    }
    
    /// Sets the user identifier in the configuration.
    /// Call this function whenever the user registers/signs-in.
    ///
    /// - Parameter id: The user identifier to be set.
    ///
    /// Example usage:
    /// ```
    /// Nophan.shared.setUserIdentifier(id: "user123")
    /// ```
    public func setUserIdentifier(id: NophanUserId) {
        self.configuration?.userId = id
        trackUser()
    }
}

extension Nophan {
    
    /// Tracks the event relating to the user's activity in the app.
    /// - Parameter event: Struct containing data related to track the event.
    public func trackEvent(_ event: NophanEventRepresentable) {
        Task.detached { [weak self] in
            do {
                guard let self else { return }
                let trackingRequest = try self.prepareRequest(for: event)
                try await self.networkEngine.request(request: trackingRequest)
            } catch {
                Log.console("Failed to track Event: \(event.name)", .error, .nophan)
            }
        }
    }
    
    /// Tracks the event relating to the app configuration.
    /// This is always tracked on app cold-starts.
    internal func trackConfiguration() {
        Task.detached { [weak self] in
            do {
                guard let self, let configuration else { throw NophanError.ConfigurationError }
                let trackingRequest = prepareRequest(for: configuration)
                try await networkEngine.request(request: trackingRequest)
            } catch {
                Log.console("Failed to track Configuration", .error, .nophan)
            }
        }
    }
    
    /// Tracks the event relating to the user's identity logging.
    /// This event is tracked when the user registers/signs-in/signs-out in the app.
    internal func trackUser() {
        Task.detached { [weak self] in
            do {
                guard let self, let configuration else { throw NophanError.ConfigurationError }
                guard let user = configuration.userId else { throw NophanError.UserIdError }
                let trackingRequest = try prepareRequest(for: user)
                try await networkEngine.request(request: trackingRequest)
            } catch {
                Log.console("Failed to track User", .error, .nophan)
            }
        }
    }
}

extension Nophan {
    
    // Prepare the request for an event.
    internal func prepareRequest(for event: NophanEventRepresentable) throws -> NophanRequest {
        var parameters: [String: Any] = ["name": event.name]
        parameters = event.parameters
            .reduce(into: parameters) { $0[$1.key] = $1.value }
        guard let configuration else { throw NophanError.ConfigurationError }
        userParameters(parameters: &parameters)
        debuggingParameters(parameters: &parameters)
        trackingTypeParameters(type: .Event, parameters: &parameters)
        additionalParameters(parameters: &parameters)
        return NophanRequest(endpointUrl: configuration.endpointUrl, parameters: parameters)
    }
    
    // Prepare the request for a configuration.
    internal func prepareRequest(for configuration: NophanConfiguration) -> NophanRequest {
        var parameters: [String:Any] = configurationParameters(configuration: configuration)
        userParameters(parameters: &parameters)
        debuggingParameters(parameters: &parameters)
        trackingTypeParameters(type: .Configuration, parameters: &parameters)
        additionalParameters(parameters: &parameters)
        return NophanRequest(endpointUrl: configuration.endpointUrl, parameters: parameters)
    }
    
    // Prepare the request for a user id.
    internal func prepareRequest(for userId: NophanUserId) throws -> NophanRequest {
        var parameters = [String:Any]()
        parameters["user"] = userId
        guard let configuration else { throw NophanError.ConfigurationError }
        debuggingParameters(parameters: &parameters)
        trackingTypeParameters(type: .User, parameters: &parameters)
        additionalParameters(parameters: &parameters)
        return NophanRequest(endpointUrl: configuration.endpointUrl, parameters: parameters)
    }
    
    // Add parameters from the Configuration
    private func configurationParameters(configuration: NophanConfiguration?) -> [String:Any] {
        guard let configuration else { return [:] }
        return [
            "app_version": configuration.appVersion,
            "device_model": configuration.deviceModel,
            "os_version": configuration.iosVersion,
            "build": configuration.build,
            "locale": configuration.locale,
            "os": configuration.operatingSystem
        ]
    }
    
    // Get a unique persisting device ID from the Keychain.
    private func getDeviceId() throws -> String {
        guard let keychain else { throw NophanError.KeychainError(.Unconfigured) }
        // if device id is available in keychain, get it.
        do {
            let deviceId = try keychain.readDeviceId()
            return deviceId
        } catch {
            if let keyChainError = error as? NophanError {
                switch keyChainError {
                case .KeychainError(.NoDeviceId):
                    let newDeviceId = UUID().uuidString
                    try keychain.saveDeviceId(value: newDeviceId)
                    return newDeviceId
                default:
                    Log.console("Some error has occured. \(error)", .error, .nophan)
                }
            }
        }
        throw NophanError.DeviceIdError
    }
    
    /// Attach debugging parameters.
    private func debuggingParameters(parameters: inout [String:Any]) {
        parameters["testing"] = debug ? true : false
    }
    
    /// Attach user parameters.
    private func userParameters(parameters: inout [String:Any]) {
        if let configuration, let user = configuration.userId {
            parameters["user"] = user
        }
    }
    
    /// Attach tracking-type parameters.
    private func trackingTypeParameters(type: TrackingType, parameters: inout [String:Any]) {
        parameters["tracking_type"] = type.parameterValue
    }
    
    /// Attach tracking-type and time-stamp parameters.
    private func additionalParameters(parameters: inout [String:Any]) {
        parameters["device_timestamp"] = Date().timeIntervalSince1970 * 1000
        parameters["unique_app_installation_id"] = try? getDeviceId()
    }
}
