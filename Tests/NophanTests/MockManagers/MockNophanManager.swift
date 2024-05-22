//
//  MockNophanManager.swift
//
//
//  Created by Usman Nazir on 20/05/2024.
//

import Foundation
@testable import Nophan

struct TestEvent: NophanEventRepresentable {
    var name: String
    var parameters: [String : Any]
}

class MockOphanManager: Analytics {
    
    var shouldFail = false
    
    var configuration: NophanConfiguration?

    var networkEngine: Networking
    
    init(networkEngine: Networking = MockNetworkEngine()) {
        self.networkEngine = networkEngine
    }
    
    func setup(configuration: NophanConfiguration) {
        self.configuration = configuration
    }
    
    func setUserIdentifier(id: NophanUserId) {
        self.configuration?.userId = id
        trackUser()
    }
    
    func trackEvent(_ event: NophanEventRepresentable) {
        guard let request = try? prepareRequest(for: event) else { return }
        Task {
            try? await networkEngine.request(request: request)
        }
    }
    
    func trackConfiguration() {
        let request = prepareRequest(for: configuration!)
        Task {
            try? await networkEngine.request(request: request)
        }
    }
    
    func trackUser() {
        guard let request = try? prepareRequest(for: configuration?.userId ?? "") else { return }
        Task {
            try? await networkEngine.request(request: request)
        }
    }
    
    func prepareRequest(for event: NophanEventRepresentable) throws -> NophanRequest {
        var parameters: [String: Any] = ["name": event.name]
        parameters = event.parameters
            .reduce(into: parameters) { $0[$1.key] = $1.value }
        guard let configuration else { throw NophanError.ConfigurationError }
        return NophanRequest(endpointUrl: configuration.endpointUrl, parameters: parameters)
    }
    
    func prepareRequest(for configuration: NophanConfiguration) -> NophanRequest {
        let configurationParameters = [
            "app_version": configuration.appVersion,
            "device_model": configuration.deviceModel,
            "os_version": configuration.iosVersion,
            "build": configuration.build,
            "locale": configuration.locale,
            "os": configuration.operatingSystem
        ]
        return NophanRequest(endpointUrl: URL(string: "https://example.endpoint.com")!, parameters: configurationParameters)
    }
    
    func prepareRequest(for userId: NophanUserId) throws -> NophanRequest {
        var parameters = [String:Any]()
        if let configuration, let user = configuration.userId {
            parameters["user"] = user
        }
        return NophanRequest(endpointUrl: URL(string: "https://example.endpoint.com")!, parameters: parameters)
    }
}
