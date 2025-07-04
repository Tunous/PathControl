//
//  StandardPathControl.swift
//  PathControl
//
//  Created by Vincent LIEGEOIS on 25/10/2024.
//

import SwiftUI

/// A SwiftUI wrapper for `NSPathControl` that supports binding to a modifiable URL.
///
/// `StandardPathControl` allows users to display and interact with a file system or virtual path.
/// It supports updating the selected path through a two-way binding.
public struct StandardPathControl: NSViewRepresentable {

    @Binding private var url: URL?

    /// Initializes a new `StandardPathControl` with a bindable URL.
    ///
    /// - Parameter url: A two-way binding to the currently selected URL.
    public init(url: Binding<URL?>) {
        self._url = url
    }

    public func makeNSView(context: Context) -> NSPathControl {
        let pathControl = NSPathControl()
        pathControl.pathStyle = .standard
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
        return PathControlDelegate(transformMenuItems: {_ in []}) { newUrl in
            self.url = newUrl
        }
    }
}

/// A SwiftUI wrapper for `NSPathControl` with a static, non-editable URL.
///
/// `StandardStaticPathControl` is useful for displaying a read-only file or virtual path in a consistent style.
public struct StandardStaticPathControl: NSViewRepresentable {

    private var url: URL

    /// Initializes a new `StandardStaticPathControl` with a static URL.
    ///
    /// - Parameter url: The URL to display.
    public init(url: URL) {
        self.url = url
    }

    public func makeNSView(context: Context) -> NSPathControl {
        let pathControl = NSPathControl()
        pathControl.pathStyle = .standard
        pathControl.url = url
        return pathControl
    }

    public func updateNSView(_ nsView: NSPathControl, context: Context) {
        nsView.url = url
    }
}
