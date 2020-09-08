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
     Construct a button with an attributed string.
     */
    public init(withAttributedTitle attributedTitle: NSAttributedString, isOn: Binding<Bool>) {
        self.attributedTitle = attributedTitle
        self._isOn = isOn
    }

    /**
     Construct a button with an image.
     */
    public init(withImage image: NSImage, isOn: Binding<Bool>) {
        self.image = image
        self._isOn = isOn
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
