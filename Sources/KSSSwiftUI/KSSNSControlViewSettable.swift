//
//  KSSNSControlViewSettable.swift
//
//  Created by Steven W. Klassen on 2020-08-02.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import os
import Cocoa
import Foundation
import SwiftUI



/**
 This protocol is used by a number of the KSS Views that use an NSControl as their basis. It allows the
 font and font size to be set.
 */
@available(OSX 10.15, *)
@available(iOS, unavailable)
public protocol KSSNSControlViewSettable {
    /// :nodoc:
    var nsControlViewSettings: KSSNSControlViewSettings { get set }
}

/**
 This object controls the settings that can be set on an `NSControl` based view.
 */
@available(OSX 10.15, *)
public class KSSNSControlViewSettings: NSObject {
    /// Specify the font. If `nil` then the controls default font will be used.
    public var font: NSFont? = nil

    /// Specify the font size. This allows the size to be changed without changing the other characteristics
    /// of the font. If `nil` then the default font size will be used.
    ///     - note: This assumes that the font has already been set or has a default. If the controls current
    ///         font cannot be determined, then setting this will log a warning message and make no change.
    public var fontSize: CGFloat? = nil
}


@available(OSX 10.15, *)
public extension KSSNSControlViewSettable {
    /**
     Apply the `NSControl` based settings to the given control. This will return true if any of the settings
     result in a change from the existing ones.
     - note: Typically this will be called in both the `makeNSView` and `updateNSView` methods of the view.
     */
    func applyNSControlViewSettings<View : NSViewRepresentable>(_ control: View.NSViewType,
                                                                context: View.Context) -> Bool
        where View.NSViewType : NSControl
    {
        var somethingChanged = false
        if let font = nsControlViewSettings.font {
            control.font = font
            somethingChanged = true
        }
        if let fontSize = nsControlViewSettings.fontSize {
            guard fontSize > 0 else {
                os_log("Warning: Invalid font size: %f, ignoring size change", fontSize)
                return somethingChanged
            }
            if let currentFont = control.font {
                let fontDescriptor = currentFont.fontDescriptor
                control.font = NSFont(descriptor: fontDescriptor, size: fontSize)
                somethingChanged = true
            } else {
                os_log("Warning: No current font is set, ignoring size change")
            }
        }
        return somethingChanged
    }
}

// MARK: NSControl View Modifiers

@available(OSX 10.15, *)
public extension NSViewRepresentable {
    /**
     Set the font in an `NSViewRepresentable` view.
     - note: If the view does not conform to the `KSSNSControlViewSettable` protocol, a warning message
        is logged and no change is make to the view.
     */
    func nsFont(_ font: NSFont) -> Self {
        if let controlViewSettable = self as? KSSNSControlViewSettable {
            controlViewSettable.nsControlViewSettings.font = font
        } else {
            os_log("Warning: View is not a KSSNSControlViewSettable, ignoring font change")
        }
        return self
    }

    /**
     Set the font size in an `NSViewRepresentable` view, without changing the other font characteristics.
     - note: If the view does not conform to the `KSSNSControlViewSettable` protocol, a warning message
        is logged and no change is make to the view.
     */
    func nsFontSize(_ fontSize: CGFloat) -> Self {
        if let controlViewSettable = self as? KSSNSControlViewSettable {
            controlViewSettable.nsControlViewSettings.fontSize = fontSize
        } else {
            os_log("Warning: View is not a KSSNSControlViewSettable, ignoring font size change")
        }
        return self
    }
}

#else

// Force the compiler to give us a more descriptive error message.
@available(iOS, unavailable)
public protocol KSSNSControlViewSettable {}

#endif
