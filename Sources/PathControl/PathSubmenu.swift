//
//  PathSubmenu.swift
//  PathControl
//
//  Created by Łukasz Rutkowski on 22/08/2020.
//

import Foundation

/// Path control pop-up menu item which can displays a submenu.
public struct PathSubmenu: PathMenuItemConvertible {

    /// Title of menu item and submenu.
    public let title: String

    let menuItems: [PathMenuItem]

    /// Creates a path menu item with given `title` that will display its children items in a submenu.
    ///
    /// - Parameters:
    ///   - title: Title of menu item and submenu.
    ///   - content: Submenu items builder..
    public init(title: String, @PathMenuBuilder content: () -> [PathMenuItem]) {
        self.title = title
        self.menuItems = content()
    }

    public func asMenuItems() -> [PathMenuItem] {
        [
            PathMenuItem(type: .item, title: title, action: {}, children: menuItems)
        ]
    }
}
