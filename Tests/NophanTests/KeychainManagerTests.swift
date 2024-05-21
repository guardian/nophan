//
//  KeychainManagerTests.swift
//
//
//  Created by Usman Nazir on 17/05/2024.
//

import XCTest
@testable import Nophan

final class KeychainManagerTests: XCTestCase {

    let testService = "com.fpa_test.FPAKeychainManagerTests"
    let testAccount = "something"
    var keychainManager: Keychain!

    override func setUp() {
        super.setUp()
        keychainManager = MockKeychainManager(service: testService, account: testAccount)
        try? keychainManager.deleteDeviceId()
    }

    override func tearDown() {
        try? keychainManager.deleteDeviceId()
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertEqual(keychainManager.service, testService)
        XCTAssertEqual(keychainManager.account, testAccount)
    }

    func testSaveDeviceId() {
        let deviceId = "device123"
        do {
            try keychainManager.saveDeviceId(value: deviceId)
            let savedDeviceId = try keychainManager.readDeviceId()
            XCTAssertEqual(savedDeviceId, deviceId, "Device ID has been saved.")
        } catch {
            XCTFail("Failed to save Device ID: \(error)")
        }
    }

    func testReadDeviceId() {
        let deviceId = "device123"
        do {
            try keychainManager.saveDeviceId(value: deviceId)
            let readDeviceId = try keychainManager.readDeviceId()
            XCTAssertEqual(readDeviceId, deviceId)
        } catch {
            XCTFail("Failed to read device ID: \(error)")
        }
    }

    func testReadNonExistentDeviceId() {
        do {
            _ = try keychainManager.readDeviceId()
            XCTFail("Expected to throw error but succeeded")
        } catch let error as NophanError {
            XCTAssertEqual(error, .KeychainError(.NoDeviceId),
                           "Error has been correctly thrown when the Device ID is absent.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testDeleteDeviceId() {
        let deviceId = "device123"
        do {
            try keychainManager.saveDeviceId(value: deviceId)
            try keychainManager.deleteDeviceId()
            XCTAssertThrowsError(try keychainManager.readDeviceId()) { error in
                XCTAssertEqual(error as? NophanError, .KeychainError(.NoDeviceId),
                               "Error has been correctly thrown when the Device ID is absent.")
            }
        } catch {
            XCTFail("Failed during delete device ID test: \(error)")
        }
    }

    func testDeleteNonExistentDeviceId() {
        do {
            try keychainManager.deleteDeviceId()
        } catch {
            XCTFail("Failed to delete non-existent device ID: \(error)")
        }
    }
}
