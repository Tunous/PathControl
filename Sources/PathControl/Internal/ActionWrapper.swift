//
//  ActionWrapper.swift
//  PathControl
//
//  Created by Łukasz Rutkowski on 22/08/2020.
//

import Foundation

class ActionWrapper {

    let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    @objc func perform() {
        action()
    }
}
