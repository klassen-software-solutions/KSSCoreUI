//
//  NativeButton.swift
//
//  Created by Steven W. Klassen on 2020-02-17.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import Cocoa
import SwiftUI


/**
 SwiftUI wrapper around an NSButton configured to act as a toggle. This is intended to be used when
 the SwiftUI `Toggle` is not sufficient, for example, when you wish to use a multi-font string or
 a tool tip.
 */
@available(OSX 10.15, *)
@available(iOS, unavailable)
public struct KSSToggle: NSViewRepresentable, KSSNativeButtonCommonHelper {
    /// Settings applicable to all KSS `NSControl` based Views.
    public var nsControlViewSettings = KSSNSControlViewSettings()

    /// Settings applicable to all KSS `NSButton` based Views.
    public var nsButtonViewSettings = KSSNSButtonViewSettings()

    /// Specifies a simple string as the content of the button.
    public private(set) var title: String? = nil

    /// Specifies an attributed string as the content of the button.
    public private(set) var attributedTitle: NSAttributedString? = nil

    /// Specifies an image as the content of the button. Note that the appearance of the image may be
    /// modified if `autoInvertImage` is specified.
    public private(set) var image: NSImage? = nil

    /// Binding to the item that will reflect the current state of the toggle.
    @Binding public var isOn: Bool

    /// Specifies an alternate image to be displayed when the button is activated. Note that the appearance
    /// of the image may be modified if `autoInvertImage` is specified.
    @available(*, deprecated, message: "Use nsButtonViewSettings.alternateImage")
    public var alternateImage: NSImage? { nsButtonViewSettings.alternateImage }

    /// If set to true, and if `image` or `alternateImage` exist, they will have their colors automatically
    /// inverted when we are displaying in "dark mode". This is most useful if they are monochrome images.
    @available(*, deprecated, message: "Use nsButtonViewSettings.autoInvertImage")
    public var autoInvertImage: Bool { nsButtonViewSettings.autoInvertImage }

    /// Allows the border to be turned on/off.
    @available(*, deprecated, message: "Use nsButtonViewSettings.isBordered")
    public var isBordered: Bool? { nsButtonViewSettings.isBordered }

    /// Allows a tool tip to be displayed if the cursor hovers over the control for a few moments.
    @available(*, deprecated, message: "Use nsButtonViewSettings.toolTip")
    public var toolTip: String? { nsButtonViewSettings.toolTip }

    let buttonType: NSButton.ButtonType? = .pushOnPushOff
    let bezelStyle: NSButton.BezelStyle? = .regularSquare

    /**
     Construct a button with a simple string.
     */
    public init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    /**
     Construct a button with a simple string.
     */
    @available(*, deprecated, message: "Use init(_, isOn:) plus modifiers")
    public init(_ title: String,
                isOn: Binding<Bool>,
                isBordered: Bool? = nil,
                toolTip: String? = nil)
    {
        self.init(title, isOn: isOn)
        self.nsButtonViewSettings.isBordered = isBordered
        self.nsButtonViewSettings.toolTip = toolTip
    }

    /**
     Construct a button with an attributed string.
     */
    public init(withAttributedTitle attributedTitle: NSAttributedString, isOn: Binding<Bool>) {
        self.attributedTitle = attributedTitle
        self._isOn = isOn
    }

    /**
     Construct a button with an attributed string.
     */
    @available(*, deprecated, message: "Use init(withAttributedTitle:, isOn:) plus modifiers")
    public init(withAttributedTitle attributedTitle: NSAttributedString,
                isOn: Binding<Bool>,
                isBordered: Bool? = nil,
                toolTip: String? = nil)
    {
        self.init(withAttributedTitle: attributedTitle, isOn: isOn)
        self.nsButtonViewSettings.isBordered = isBordered
        self.nsButtonViewSettings.toolTip = toolTip
    }

    /**
     Construct a button with an image.
     */
    public init(withImage image: NSImage, isOn: Binding<Bool>) {
        self.image = image
        self._isOn = isOn
    }

    /**
     Construct a button with an image.
     */
    @available(*, deprecated, message: "Use init(withImage:, isOn:) plus modifiers")
    public init(withImage image: NSImage,
                isOn: Binding<Bool>,
                alternateImage: NSImage? = nil,
                autoInvertImage: Bool = true,
                isBordered: Bool? = nil,
                toolTip: String? = nil)
    {
        self.init(withImage: image, isOn: isOn)
        self.nsButtonViewSettings.alternateImage = alternateImage
        self.nsButtonViewSettings.autoInvertImage = autoInvertImage
        self.nsButtonViewSettings.isBordered = isBordered
        self.nsButtonViewSettings.toolTip = toolTip
    }

    /// :nodoc:
    public func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = commonMakeButton(context: context)
        button.onAction { _ in self.isOn = !self.isOn }
        return button
    }

    /// :nodoc:
    public func updateNSView(_ button: NSButton, context: NSViewRepresentableContext<Self>) {
        DispatchQueue.main.async {
            self.commonUpdateButton(button, context: context)
            button.state = self.isOn ? .on : .off
            if button.alternateImage == nil {
                button.alphaValue = self.isOn ? 1.0 : 0.8
            }
        }
    }
}

#else

// Force the compiler to give us a more descriptive error message.
@available(iOS, unavailable)
public struct KSSToggle {}

#endif
