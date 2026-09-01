import XCTest
@testable import GTA6Companion

final class NetworkTests: XCTestCase {
    
    func testNetworkErrorDescription() {
        let invalidURLError = NetworkError.invalidURL
        XCTAssertEqual(invalidURLError.localizedDescription, "Invalid URL")
        
        let noDataError = NetworkError.noData
        XCTAssertEqual(noDataError.localizedDescription, "No data received")
        
        let serverError = NetworkError.serverError("Something went wrong")
        XCTAssertEqual(serverError.localizedDescription, "Something went wrong")
    }
    
    func testKeychainSave() {
        let manager = StorageManager.shared
        manager.saveToken("test_token")
        
        let token = manager.getToken()
        XCTAssertEqual(token, "test_token")
        
        manager.deleteToken()
        XCTAssertNil(manager.getToken())
    }
}
