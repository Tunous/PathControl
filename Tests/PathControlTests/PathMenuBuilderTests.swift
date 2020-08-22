import XCTest
import SwiftUI

@testable import PathControl

final class PathMenuBuilderTests: XCTestCase {

    func testCanBuildSingleItem() {
        assertBuilder(expectedItems: [PathMenuItem(title: "Abc")]) {
            PathMenuItem(title: "Abc")
        }
    }

    func testCanBuildDivider() {
        assertBuilder(expectedItems: [PathMenuItem(type: .divider, title: "")]) {
            Divider()
        }
    }

    func testCanBuildArray() {
        assertBuilder(expectedItems: [PathMenuItem(title: "A"), PathMenuItem(title: "B")]) {
            [PathMenuItem(title: "A"), PathMenuItem(title: "B")]
        }
    }

    func testCanBuildMultipleItems() {
        assertBuilder(expectedItems: [PathMenuItem(title: "A"), PathMenuItem(title: "B")]) {
            PathMenuItem(title: "A")
            PathMenuItem(title: "B")
        }
    }

    func testCanUseIfElse() {
        let condition = true
        assertBuilder(expectedItems: [PathMenuItem(title: "A")]) {
            if condition {
                PathMenuItem(title: "A")
            } else {
                PathMenuItem(title: "B")
            }
        }
        assertBuilder(expectedItems: [PathMenuItem(title: "B")]) {
            if !condition {
                PathMenuItem(title: "A")
            } else {
                PathMenuItem(title: "B")
            }
        }
    }

    func testCanUseIfLet() {
        let title: String? = "A"
        assertBuilder(expectedItems: [PathMenuItem(title: "A")]) {
            if let title = title {
                PathMenuItem(title: title)
            }
        }
    }

    func testCanUseSwitch() {
        assertBuilder(expectedItems: [PathMenuItem(title: "match")]) {
            switch "match" {
            case "not a match":
                PathMenuItem(title: "not a match")
            case "match":
                PathMenuItem(title: "match")
            default:
                PathMenuItem(title: "fallback")
            }

        }
    }

    func testCanUseOptional() {
        let itemA: PathMenuItem? = PathMenuItem(title: "A")
        let itemB: PathMenuItem? = nil
        assertBuilder(expectedItems: [PathMenuItem(title: "A")]) {
            itemA
            itemB
        }
    }

    func testCanUseDo() {
        assertBuilder(expectedItems: [PathMenuItem(title: "A")]) { () -> [PathMenuItem] in
            do {
                PathMenuItem(title: "A")
            }
        }
    }

    private func assertBuilder(expectedItems: [PathMenuItem], @PathMenuBuilder content: () -> [PathMenuItem]) {
        let createdItems = content()
        XCTAssertEqual(createdItems.count, expectedItems.count, "Incorrect number of created items")
        zip(expectedItems, createdItems).forEach { expectedItem, createdItem in
            XCTAssertEqual(createdItem.title, expectedItem.title, "Item titles are different")
            XCTAssertEqual(createdItem.type, expectedItem.type, "Item types are different")
        }
    }

    static var allTests = [
        ("testCanBuildSingleItem", testCanBuildSingleItem),
        ("testCanBuildDivider", testCanBuildDivider),
        ("testCanBuildArray", testCanBuildArray),
        ("testCanBuildMultipleItems", testCanBuildMultipleItems),
        ("testCanUseIfElse", testCanUseIfElse),
        ("testCanUseIfLet", testCanUseIfLet),
        ("testCanUseSwitch", testCanUseSwitch),
        ("testCanUseOptional", testCanUseOptional),
        ("testCanUseDo", testCanUseDo),
    ]
}
