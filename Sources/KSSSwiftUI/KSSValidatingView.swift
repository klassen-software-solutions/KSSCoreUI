//
//  KSSValidatingView.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-14.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//  Released under the MIT license.
//

import os
import Foundation
import KSSCocoa
import SwiftUI


/**
 This protocol specifies the API required in order to support the `errorHighlight` and `validator`
 view modifiers.
 */
public protocol KSSValidatingView {
    /// The type of the object to be validated.
    associatedtype ValidatedType

    /// The type of the color to be used. This must be either `NSColor` (for
    /// `NSViewRepresentable` objects) or `Color` (for all other View objects).
    associatedtype ColorType

    /// The color used to highlight things if the validation fails.
    var errorHighlightColor: ColorType { get set }

    /// The callback used to validate an object.
    var validatorFn: ((ValidatedType) -> Bool)? { get set }
}


// MARK: View Modifiers

@available(OSX 10.15, *)
public extension KSSValidatingView {
    /**
     Returns a modified View with the validation function set.
     */
    func validator(perform: @escaping (ValidatedType) -> Bool) -> Self {
        var newView = self
        newView.validatorFn = perform
        return newView
    }
}

#if canImport(Cocoa)
// TODO: deprecate this? In theory the more general one below should be sufficient
public extension KSSValidatingView where ColorType == NSColor {
    /**
     Returns a modified View with the color used for the error highlights set.
     */
    func errorHighlight(_ color: NSColor? = nil) -> Self {
        var newView = self
        newView.errorHighlightColor = color ?? NSColor.errorHighlightColor
        return newView
    }
}
#endif

@available(OSX 10.15, *)
public extension KSSValidatingView where ColorType == Color {
    /**
     Returns a modified View with the color used for the error highlights set.
     */
    func errorHighlight(_ color: Color? = nil) -> Self {
        var newView = self
#if canImport(Cocoa)
        newView.errorHighlightColor = color ?? Color(NSColor.errorHighlightColor)
#else
        // TODO: Add a UIColor.errorHighlightColor. This may require adding a UIKit
        //  package, or perhaps renaming KSSCocoa to to something more general
        //  (perhaps KSSNativeUI?) to allow it to contain lower level Cocoa and UIKit
        //  items.
        newView.errorHighlightColor = color ?? Color.yellow.opacity(0.5)
#endif
        return newView
    }
}
