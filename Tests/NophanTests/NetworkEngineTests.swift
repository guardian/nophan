//
//  NetworkEngineTests.swift
//
//
//  Created by Usman Nazir on 20/05/2024.
//

import XCTest
@testable import Nophan

final class NetworkEngineTests: XCTestCase {
    
    var networkEngine: MockNetworkEngine!
    
    override func setUpWithError() throws {
        networkEngine = MockNetworkEngine()
    }
    
    override func tearDownWithError() throws {
        networkEngine = nil
    }
    
    func testDeviceTimestampRemainsSameAfterRetry() async {
        let endpointUrl = URL(string: "https://example.com/api")!
        let deviceTimestamp = Date().timeIntervalSince1970
        let parameters: [String: Any] = ["device_timestamp": deviceTimestamp]
        let request = NophanRequest(endpointUrl: endpointUrl, parameters: parameters)
        
        networkEngine.shouldFail = true
        do {
            try await networkEngine.request(request: request)
        } catch {
            // Expected failure, do nothing
        }
        
        // Wait before retry
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1 second
        
        XCTAssertEqual(networkEngine.failedTasksQueue.last?.parameters["device_timestamp"] as? TimeInterval, deviceTimestamp,
                       "The Device Time-stamp should remain same event if the attempt is resumed after some time.")
        
        networkEngine.shouldFail = false
        networkEngine.retryFailedRequests()
        
        XCTAssertEqual(networkEngine.failedTasksQueue.count, 0,
                       "The number of failed requests is 0 once the network engine is running properly.")
    }
}
