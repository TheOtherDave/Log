import XCTest
@testable import Log

class LogTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotEqual("\(Log())", "Hello, World!")
    }


    static var allTests : [(String, (LogTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
