//
//  PopUpPathControl.swift
//  PathControl
//
//  Created by Łukasz Rutkowski on 16/08/2020.
//

import SwiftUI

/// A control for display of a file system path or virtual path information.
public struct PopUpPathControl: NSViewRepresentable {

    @ObservedObject private var delegate = PathControlDelegate()
    @Binding private var url: URL?

    /// Creates a pop-up path control.
    ///
    /// - Parameter url: A binding to property that defines the currently-selected url.
    /// - Parameter content: Contents of pop-up menu.
    public init(url: Binding<URL?>, @PathMenuBuilder content: @escaping ([PathMenuItem]) -> [PathMenuItem]) {
        self._url = url
        self.delegate.transformMenuItems = content
    }

    public func makeNSView(context: Context) -> NSPathControl {
        let pathControl = NSPathControl()
        pathControl.pathStyle = .popUp
        pathControl.url = url

        delegate.urlChanged = { newUrl in
            self.url = newUrl
        }
        pathControl.target = delegate
        pathControl.action = #selector(delegate.pathItemClicked)
        pathControl.delegate = delegate

        return pathControl
    }

    public func updateNSView(_ nsView: NSPathControl, context: Context) {
        nsView.url = url
    }
}
