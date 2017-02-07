import XCTest
@testable import Log

class LogTests: XCTestCase {
    // FIXME: This essentially just tests that we can compile... It's seriously useless.
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert("\(Log())" != "Hello, World!")
    }


    static var allTests : [(String, (LogTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
