//
//  MockKeychainManager.swift
//
//
//  Created by Usman Nazir on 20/05/2024.
//

import Foundation
@testable import Nophan

class MockKeychainManager: Keychain {
    
    let service: String
    private(set) var account: String
    private var storage: [String: Any] = [:]
    
    init(service: String, account: String) {
        self.service = service
        self.account = account
    }
    
    func readDeviceId() throws -> String {
        if let deviceId = storage["device_id"] as? String {
            return deviceId
        } else {
            throw NophanError.KeychainError(.NoDeviceId)
        }
    }
    
    func saveDeviceId(value: String) throws {
        storage["device_id"] = value
    }
    
    func deleteDeviceId() throws {
        storage = [:]
    }
}
