//
//  KSSNSButtonViewSettable.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-06.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import os
import Cocoa
import Foundation
import SwiftUI



/**
 This protocol is used by a number of KSS Views that use an NSButton as their basis. It allows a number of
 their settings, common to most buttons, to be set via modifiers.
 */
@available(OSX 10.15, *)
@available(iOS, unavailable)
public protocol KSSNSButtonViewSettable : KSSNSControlViewSettable {
    /// :nodoc:
    var nsButtonViewSettings: KSSNSButtonViewSettings { get set }
}


/**
 This object controls the settings that can be set on an `NSButton` based view.
 */
@available(OSX 10.15, *)
public class KSSNSButtonViewSettings: NSObject {
    /// Specifies an alternate image to be displayed when the button is activated. Note that the appearance
    /// of the image may be modified if `autoInvertImage` is specified.
    public var alternateImage: NSImage? = nil

    /// If set to true, and if `image` or `alternateImage` exist, they will have their colors automatically
    /// inverted when we are displaying in "dark mode". This is most useful if they are monochrome images.
    public var autoInvertImage: Bool = true

    /// Allows the border to be turned on/off.
    public var isBordered: Bool? = nil

    /// If true then the button's border is only displayed when the pointer is over the button and the
    /// button is active.
    public var showsBorderOnlyWhileMouseInside: Bool? = nil

    /// Allows a tool tip to be displayed if the cursor hovers over the control for a few moments.
    public var toolTip: String? = nil
}


@available(OSX 10.15, *)
public extension KSSNSButtonViewSettable {
    /**
     Apply the `NSButton` based settings, including the `NSControl` settings, to the given control. This will
     return true if any of the settings result in a change from the existing ones.
     - note: Typically this will be called in both the `makeNSView` and `updateNSView` methods of the view.
     - note: This method also calls `applyNSControlViewSettings` so you don't need to call it again.
     */
    func applyNSButtonViewSettings<View : NSViewRepresentable>(_ control: View.NSViewType,
                                                               context: View.Context) -> Bool
        where View.NSViewType : NSButton
    {
        var somethingChanged = applyNSControlViewSettings(control, context: context)
        if let image = nsButtonViewSettings.alternateImage {
            if control.alternateImage != image {
                let colorScheme = context.environment.colorScheme
                let shouldInvert = nsButtonViewSettings.autoInvertImage && (colorScheme == .dark)
                control.alternateImage = shouldInvert ? image.inverted() : image
                somethingChanged = true
            }
        }
        if let isBordered = nsButtonViewSettings.isBordered {
            if control.isBordered != isBordered {
                control.isBordered = isBordered
                somethingChanged = true
            }
        }
        if let showBorder = nsButtonViewSettings.showsBorderOnlyWhileMouseInside {
            if control.showsBorderOnlyWhileMouseInside != showBorder {
                control.showsBorderOnlyWhileMouseInside = showBorder
                somethingChanged = true
            }
        }
        if let toolTip = nsButtonViewSettings.toolTip {
            if control.toolTip != toolTip {
                control.toolTip = toolTip
                somethingChanged = true
            }
        }
        return somethingChanged
    }
}

// MARK: NSButton View Modifiers

@available(OSX 10.15, *)
public extension NSViewRepresentable {
    /**
     Set the alternate image in an `NSViewRepresentable` view.
     - note: If the view is not a `KSSNSButtonViewSettable` view, then a warning will be logged and no change made.
     */
    func nsAlternateImage(_ image: NSImage) -> Self {
        if let buttonView = self as? KSSNSButtonViewSettable {
            buttonView.nsButtonViewSettings.alternateImage = image
        } else {
            os_log("Warning: View is not a KSSNSButtonViewSettable, ignoring alternate image change")
        }
        return self
    }

    /**
     Automatically invert the image and alternate image when in dark mode.
     - note: If the view is not a `KSSNSButtonViewSettable` view, then a warning will be logged and no change made.
     */
    func nsAutoInvertImage(_ autoInvert: Bool) -> Self {
        if let buttonView = self as? KSSNSButtonViewSettable {
            buttonView.nsButtonViewSettings.autoInvertImage = autoInvert
        } else {
            os_log("Warning: View is not a KSSNSButtonViewSettable, ignoring auto invert image change")
        }
        return self
    }

    /**
     Turn the border on/off.
     - note: If the view is not a `KSSNSButtonViewSettable` view, then a warning will be logged and no change made.
     */
    func nsIsBordered(_ isBordered: Bool) -> Self {
        if let buttonView = self as? KSSNSButtonViewSettable {
            buttonView.nsButtonViewSettings.isBordered = isBordered
        } else {
            os_log("Warning: View is not a KSSNSButtonViewSettable, ignoring is bordered change")
        }
        return self
    }

    /**
     Show the border only when the mouse is inside.
     - note: If the view is not a `KSSNSButtonViewSettable` view, then a warning will be logged and no change made.
     */
    func nsShowsBorderOnlyWhileMouseInside(_ showBorder: Bool) -> Self {
        if let buttonView = self as? KSSNSButtonViewSettable {
            buttonView.nsButtonViewSettings.showsBorderOnlyWhileMouseInside = showBorder
        } else {
            os_log("Warning: View is not a KSSNSButtonViewSettable, ignoring show border change")
        }
        return self
    }

    /**
     Show a tooltip when the mouse hovers over the button.
     - note: If the view is not a `KSSNSButtonViewSettable` view, then a warning will be logged and no change made.
     */
    func nsToolTip(_ toolTip: String) -> Self {
        if let buttonView = self as? KSSNSButtonViewSettable {
            buttonView.nsButtonViewSettings.toolTip = toolTip
        } else {
            os_log("Warning: View is not a KSSNSButtonViewSettable, ignoring tool tip change")
        }
        return self
    }
}

#else

// Force the compiler to give us a more descriptive error message.
@available(iOS, unavailable)
public protocol KSSNSButtonViewSettable {}

#endif
