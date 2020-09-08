//
//  NSViewExtension.swift
//  WSTerminal
//
//  Created by Steven W. Klassen on 2020-02-24.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import Cocoa
import SwiftUI


public extension NSView {
    /**
     Returns the SwiftUI original root content hosted by this view. Note that this is a copy of the view
     before any modifiers have been applied.

     - warning:
     SwiftUI views are structs hence what is returned is a copy of the view. The intended purpose of this
     is for examining the state and using it to update things that cannot be done using just SwiftUI controls.
     You cannot use this to modify the view itself, although depending on the view's `@State` and other
     data, you may be able to modify that portion of the object. But that will be highly dependant on the
     details of the view itself.

     - warning:
     Due to the current limitations of Swift Generics, this method must rely on `Mirror` based reflection
     in order to find the original root view.

     - returns:
     A copy of the original `View` or `nil` if this is not an `NSHostingView` that contains a view
     of the type specified by `RootView`.
     */
    @available(OSX 10.15, *)
    func originalRootView<RootView: View>() -> RootView? {
        if let hostingView = self as? NSHostingView<RootView> {
            return hostingView.rootView
        }
        let mirror = Mirror(reflecting: self)
        if let rootView = mirror.descendant("_rootView") {
            let mirror2 = Mirror(reflecting: rootView)
            if let content = mirror2.descendant("content") as? RootView {
                return content
            }
        }
        return nil
    }
}

#endif
