//
//  StandardPathControl.swift
//  PathControl
//
//  Created by Vincent LIEGEOIS on 25/10/2024.
//

import SwiftUI

/// A control for display of a file system path or virtual path information.
public struct StandardPathControl: NSViewRepresentable {

    @Binding private var url: URL?

    /// Creates a standard path control.
    ///
    /// - Parameter url: A binding to property that defines the currently-selected url.
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

/// A control for display of a file system path or virtual path information.
public struct StandardStaticPathControl: NSViewRepresentable {

    private var url: URL

    /// Creates a standard path control.
    ///
    /// - Parameter url: A binding to property that defines the currently-selected url.
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
