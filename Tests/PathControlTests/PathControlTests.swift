import XCTest
@testable import PathControl

final class PathControlTests: XCTestCase {
    func testCanCreateEmptyPopUp() {
        XCTAssertNotNil(PopUpPathControl(url: .constant(nil)) { _ in })
    }

    static var allTests = [
        ("testCanCreateEmptyPopUp", testCanCreateEmptyPopUp),
    ]
}
