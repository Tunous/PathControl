//
//  PathControlDelegate.swift
//  PathControl
//
//  Created by Łukasz Rutkowski on 15/08/2020.
//

import Foundation
import SwiftUI

public final class PathControlDelegate: NSObject {

    private let transformMenuItems: ([PathMenuItem]) -> [PathMenuItem]
    private let urlChanged: (URL?) -> Void
    var actions = [ActionWrapper]()

    init(
        transformMenuItems: @escaping ([PathMenuItem]) -> [PathMenuItem],
        urlChanged: @escaping (URL?) -> Void
    ) {
        self.transformMenuItems = transformMenuItems
        self.urlChanged = urlChanged
    }

    @objc func pathItemClicked(_ sender: NSPathControl) {
        urlChanged(sender.clickedPathItem?.url)
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
                let action = ActionWrapper(action: item.action)
                actions.append(action)

                let newItem = NSMenuItem(title: item.title, action: #selector(action.perform), keyEquivalent: "")
                newItem.target = action

                if !item.children.isEmpty {
                    let submenu = NSMenu(title: item.title)
                    submenu.items = createMenu(from: item.children, fileChooserItem: fileChooserItem)
                    newItem.submenu = submenu
                }
                return newItem
            }
        }
    }
}

extension PathControlDelegate: NSPathControlDelegate {

    public func pathControl(_ pathControl: NSPathControl, willPopUp menu: NSMenu) {
        actions = []

        let fileChooserItem = menu.item(at: 0)!
        let pathMenuItems: [NSMenuItem]
        if menu.items.count > 2 {
            pathMenuItems = (2..<menu.numberOfItems).compactMap { menu.item(at: $0) }
        } else {
            pathMenuItems = []
        }

        let originalPathItems = pathMenuItems.map {
            PathMenuItem(type: .wrapped($0), title: $0.title)
        }
        let menuDefinition = transformMenuItems(originalPathItems)
        menu.items = createMenu(from: menuDefinition, fileChooserItem: fileChooserItem)
    }
}

extension PathMenuItem {

    func build(basedOn menuItem: NSMenuItem) -> NSMenuItem {
        let menuItemCopy = menuItem.copy() as! NSMenuItem
        menuItemCopy.title = title
        return menuItemCopy
    }
}
