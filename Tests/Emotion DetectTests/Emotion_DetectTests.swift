import XCTest
@testable import Emotion_Detect

class Emotion_DetectTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Emotion_Detect().text, "Hello, World!")
    }


    static var allTests : [(String, (Emotion_DetectTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
