//
//  PopUpPathControl.swift
//  PathControl
//
//  Created by Łukasz Rutkowski on 16/08/2020.
//

import SwiftUI

/// A control for display of a file system path or virtual path information.
public struct PopUpPathControl: NSViewRepresentable {

    @Binding private var url: URL?
    private let transformMenuItems: ([PathMenuItem]) -> [PathMenuItem]

    /// Creates a pop-up path control with its content created based on provided builder.
    ///
    /// - Parameter url: A binding to property that defines the currently-selected url.
    /// - Parameter content: Contents of pop-up menu.
    public init(url: Binding<URL?>, @PathMenuBuilder content: @escaping ([PathMenuItem]) -> [PathMenuItem]) {
        self._url = url
        self.transformMenuItems = content
    }

    /// Creates a pop-up path control with default contents.
    ///
    /// - Parameter url: A binding to property that defines the currently-selected url.
    public init(url: Binding<URL?>, fileChooser: Bool = false) {
        self._url = url
        self.transformMenuItems = { currentPathItems in
            if fileChooser {
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
