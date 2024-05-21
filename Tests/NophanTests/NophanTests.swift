import XCTest
@testable import Nophan

final class NophanTests: XCTestCase {
    
    var networkEngine: MockNetworkEngine!
    var nophan: MockOphanManager!
    
    let endpointUrl = URL(string: "https://example.com/api")!
    
    override func setUpWithError() throws {
        networkEngine = MockNetworkEngine()
        networkEngine.shouldFail = true
        nophan = MockOphanManager(networkEngine: networkEngine)
    }
    
    override func tearDownWithError() throws {
        networkEngine = nil
        nophan = nil
    }
    
    func testSetupConfiguration() async {
        let configuration = NophanConfiguration(endpointUrl: endpointUrl)
        nophan.setup(configuration: configuration)
        XCTAssertEqual(nophan.configuration?.endpointUrl, configuration.endpointUrl, "Endpoint matches the correct value")
        XCTAssertEqual(nophan.configuration?.userId, nil, "User ID is nil as expected")
    }
    
    func testTrackEventWithoutConfiguration() async {
        let event = TestEvent(name: "Test", parameters: ["event": "testEvent"])
        nophan.trackEvent(event)
        XCTAssertEqual(networkEngine.failedTasksQueue.count, 0, "No new request has been added.")
    }
    
    func testSetUserIdentifier() async {
        let userId = "user123"
        let configuration = NophanConfiguration(endpointUrl: endpointUrl)
        
        nophan.setup(configuration: configuration)
        nophan.setUserIdentifier(id: userId)
        
        XCTAssertEqual(nophan.configuration?.userId, userId, "User Id correctly matches the provided value.")
    }
    
    func testTrackEvent() async {
        let event = TestEvent(name: "Test", parameters: ["event": "testEvent"])
        let configuration = NophanConfiguration(endpointUrl: endpointUrl)
        nophan.setup(configuration: configuration)
        nophan.trackEvent(event)
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        XCTAssertEqual(networkEngine.failedTasksQueue.count, 1)
        XCTAssertEqual(networkEngine.failedTasksQueue.last?.parameters["name"] as! String, "Test")
    }
    
    func testTrackConfiguration() async {
        let configuration = NophanConfiguration(endpointUrl: endpointUrl)
        nophan.setup(configuration: configuration)
        nophan.trackConfiguration()
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        XCTAssertEqual(networkEngine.failedTasksQueue.count, 1)
        XCTAssertEqual(networkEngine.failedTasksQueue.last?.parameters["os"] as? String, configuration.operatingSystem)
    }
    
    func testTrackUser() async {
        let userId = "user123"
        let configuration = NophanConfiguration(endpointUrl: endpointUrl)
        nophan.setup(configuration: configuration)
        nophan.setUserIdentifier(id: userId)
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        XCTAssertEqual(networkEngine.failedTasksQueue.count, 1)
        XCTAssertEqual(networkEngine.failedTasksQueue.last?.parameters["user"] as? String, "user123")
    }
}
