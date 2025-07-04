//
//  PathSubmenu.swift
//  PathControl
//
//  Created by Łukasz Rutkowski on 22/08/2020.
//

import Foundation

/// A pop-up menu item in a path control that displays a submenu of additional path items.
///
/// Use `PathSubmenu` to group related `PathMenuItem`s under a titled submenu entry in the path control menu.
public struct PathSubmenu: PathMenuItemConvertible {
    
    /// Title of menu item and submenu.
    public let title: String
    
    let menuItems: [PathMenuItem]
    
    /// Initializes a submenu with the specified title and content items.
    ///
    /// - Parameters:
    ///   - title: The title for the menu item and its submenu.
    ///   - content: A builder that returns the submenu items to be included under this entry.
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
