//
//  PopUpPathControl.swift
//  PathControl
//
//  Created by Łukasz Rutkowski on 16/08/2020.
//

import SwiftUI

/// A SwiftUI wrapper for `NSPathControl` in pop-up style, allowing customization of the displayed menu items.
///
/// `PopUpPathControl` enables users to navigate and select a path using a pop-up menu. The contents of the menu
/// can be customized via a `PathMenuBuilder`.
public struct PopUpPathControl: NSViewRepresentable {

    @Binding private var url: URL?
    private let transformMenuItems: ([PathMenuItem]) -> [PathMenuItem]

    /// Initializes a `PopUpPathControl` with custom menu contents.
    ///
    /// - Parameters:
    ///   - url: A binding to the currently selected URL.
    ///   - content: A closure that defines the menu items shown in the pop-up path control.
    public init(
        url: Binding<URL?>,
        @PathMenuBuilder content: @escaping ([PathMenuItem]) -> [PathMenuItem]
    ) {
        self._url = url
        self.transformMenuItems = content
    }

    /// Initializes a `PopUpPathControl` with optional file chooser.
    ///
    /// - Parameters:
    ///   - url: A binding to the currently selected URL.
    ///   - includeFileChooser: Whether to include a standard file chooser item in the menu. Defaults to `true`.
    public init(url: Binding<URL?>, includeFileChooser: Bool = true) {
        self._url = url
        self.transformMenuItems = { currentPathItems in
            if includeFileChooser {
                let defaultItems = [
                    PathMenuItem.fileChooser(),
                    PathMenuItem(type: .divider, title: "")
                ]
                return defaultItems + currentPathItems
            } else {
                return currentPathItems
            }
        }
    }

    public func makeNSView(context: Context) -> NSPathControl {
        let pathControl = NSPathControl()
        pathControl.pathStyle = .popUp
        pathControl.url = url
        pathControl.target = context.coordinator
        pathControl.action = #selector(context.coordinator.pathItemClicked)
        pathControl.delegate = context.coordinator
        return pathControl
    }

    public func updateNSView(_ nsView: NSPathControl, context: Context) {
        nsView.url = url
    }

    public func makeCoordinator() -> PathControlDelegate {
        return PathControlDelegate(transformMenuItems: transformMenuItems) { newUrl in
            self.url = newUrl
        }
    }
}
