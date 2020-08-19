//
//  PathControlDelegate.swift
//  PathControl
//
//  Created by Łukasz Rutkowski on 15/08/2020.
//

import Foundation
import SwiftUI

final class PathControlDelegate: NSObject, ObservableObject, NSPathControlDelegate {

    var transformMenuItems: ([PathMenuItem]) -> [PathMenuItem] = { $0 }
    var urlChanged: (URL?) -> Void = { _ in }

    @objc func pathItemClicked(_ sender: NSPathControl) {
        urlChanged(sender.clickedPathItem?.url)
    }

    func pathControl(_ pathControl: NSPathControl, willPopUp menu: NSMenu) {
        let fileChooserItem = menu.item(at: 0)!
        let pathMenuItems = (2..<menu.numberOfItems).compactMap { menu.item(at: $0) }

        let originalPathItems = pathMenuItems.map {
            PathMenuItem(type: .wrapped($0), title: $0.title)
        }
        let menuDefinition = transformMenuItems(originalPathItems)
        menu.items = createMenu(from: menuDefinition, fileChooserItem: fileChooserItem)
    }

    private func createMenu(from definingMenuItems: [PathMenuItem], fileChooserItem: NSMenuItem) -> [NSMenuItem] {
        return definingMenuItems.map { item in
            switch item.type {
            case .divider:
                return .separator()

            case .fileChooser:
                return item.build(basedOn: fileChooserItem)

            case .wrapped(let wrappedMenuItem):
                return item.build(basedOn: wrappedMenuItem)

            case .item:
                let newItem = NSMenuItem(title: item.title, action: nil, keyEquivalent: "")
                return newItem
            }
        }
    }
}

extension PathMenuItem {

    func build(basedOn menuItem: NSMenuItem) -> NSMenuItem {
        let menuItemCopy = menuItem.copy() as! NSMenuItem
        menuItemCopy.title = title
        return menuItemCopy
    }
}
