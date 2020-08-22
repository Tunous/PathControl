import XCTest
import SwiftUI

@testable import PathControl

final class PathMenuBuilderTests: XCTestCase {

    private let itemA = PathMenuItem(title: "A", action: {})
    private let itemB = PathMenuItem(title: "B", action: {})

    func testCanBuildSingleItem() {
        assertBuilder(expectedItems: [itemA]) {
            itemA
        }
    }

    func testCanBuildDivider() {
        assertBuilder(expectedItems: [PathMenuItem(type: .divider, title: "")]) {
            Divider()
        }
    }

    func testCanBuildArray() {
        assertBuilder(expectedItems: [itemA, itemB]) {
            [itemA, itemB]
        }
    }

    func testCanBuildMultipleItems() {
        assertBuilder(expectedItems: [itemA, PathMenuItem(title: "B", action: {})]) {
            itemA
            PathMenuItem(title: "B", action: {})
        }
    }

    func testCanUseIfElse() {
        let condition = true
        assertBuilder(expectedItems: [itemA]) {
            if condition {
                itemA
            } else {
                PathMenuItem(title: "B", action: {})
            }
        }
        assertBuilder(expectedItems: [PathMenuItem(title: "B", action: {})]) {
            if !condition {
                itemA
            } else {
                PathMenuItem(title: "B", action: {})
            }
        }
    }

    func testCanUseIfLet() {
        let title: String? = "A"
        assertBuilder(expectedItems: [itemA]) {
            if let title = title {
                PathMenuItem(title: title, action: {})
            }
        }
    }

    func testCanUseSwitch() {
        assertBuilder(expectedItems: [PathMenuItem(title: "match", action: {})]) {
            switch "match" {
            case "not a match":
                PathMenuItem(title: "not a match", action: {})
            case "match":
                PathMenuItem(title: "match", action: {})
            default:
                PathMenuItem(title: "fallback", action: {})
            }

        }
    }

    func testCanUseOptional() {
        let optionalA: PathMenuItem? = PathMenuItem(title: "A", action: {})
        let optionalB: PathMenuItem? = nil
        assertBuilder(expectedItems: [itemA]) {
            optionalA
            optionalB
        }
    }

    func testCanUseDo() {
        assertBuilder(expectedItems: [itemA]) { () -> [PathMenuItem] in
            do {
                itemA
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
