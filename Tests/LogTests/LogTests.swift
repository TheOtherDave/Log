import XCTest
@testable import Log

class LogTests: XCTestCase {
    func testBasicIterationStuff() {
        let log = Log<String>()
        var count = 0
        for _ in log {
            count += 1
        }
        XCTAssert(count == 0)
    }
    
    func testLogging() {
        let log = Log<String>()
        var logStr = ""
        log[] = "this is the"
        log[] = "song that"
        log[] = "nev<NO CARRIER>"
        var count = 0
        for entry in log {
            count += 1
            logStr += "\(entry)"
        }
        XCTAssert(log.count == 3)
        XCTAssert(logStr != "")
    }
    func testKeySearch() {
        let log = Log<String>()
        log[] = "this is the"
        log[] = "song that"
        usleep(1000001)
        log[] = "nev<NO CARRIER>"
        let recentEntries = log.filter { $0.key.timeIntervalSince(Date()) > -1 }
        XCTAssert(recentEntries.count == 1)
    }
    func testTagSearch() {
        let log = Log<String>()
        log[] = "this is the"
        log[] = (entry: "song that", tags: ["the end", "the middle"])
        log[] = (entry: "nev<NO CARRIER>", tag: "the end")
        let ending = log.filter { $0.tags.contains("the end") }
        let middle = log.filter {$0.tags.contains("the middle")}
        let untagged = log.filter { $0.tags.isEmpty }
        let wrongTag = log.filter { $0.tags.contains("the beginning") }
        XCTAssert(ending.count == 2)
        XCTAssert(middle.count == 1)
        XCTAssert(untagged.count == 1)
        XCTAssert(wrongTag.count == 0)
    }
    func testUpdateTag() {
        let log = Log<String>()
        log[] = "this is the"
        log[] = "song that"
        log[] = "nev<NO CARRIER>"
        var untagged = log.filter { $0.tags.isEmpty }
        XCTAssert(untagged.count == 3)
        log.tag("tag")
        untagged = log.filter { $0.tags.isEmpty }
        print("tags = \(log[log._lastDate!]?.tags)")
        XCTAssert(untagged.count == 2)
        
    }
    static var allTests : [(String, (LogTests) -> () throws -> Void)] {
        return [
            ("Test Basic Iteration", testBasicIterationStuff),
            ("Test Logging", testLogging),
        ]
    }
}
