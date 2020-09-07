//
//  NativeButton.swift
//
//  Created by Steven W. Klassen on 2020-02-17.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import os
import Cocoa
import KSSCocoa
import SwiftUI


/**
 SwiftUI wrapper around an NSButton. This is intended to be used when a SwiftUI Button is not sufficient.
 For example, when you wish to use a multi-font string, or alllow a default action.

 This wrapper allows many of the configuration items available for NSButton to be used.

 - note: This is based on example code found at
    https://stackoverflow.com/questions/57283931/swiftui-on-mac-how-do-i-designate-a-button-as-being-the-primary
 */
@available(OSX 10.15, *)
@available(iOS, unavailable)
public struct KSSNativeButton: NSViewRepresentable, KSSNativeButtonCommonHelper {

    /// Settings applicable to all KSS `NSControl` based Views.
    public var nsControlViewSettings = KSSNSControlViewSettings()

    /// Settings applicable to all KSS `NSButton` based Views.
    public var nsButtonViewSettings = KSSNSButtonViewSettings()

    /**
     Used to specify a keyboard equivalent to the button action. This can either refer to the return key or
     the escape key.
     */
    public enum KeyEquivalent: String {
        /// Represents the escape key.
        case escape = "\u{1b}"

        /// Represents the return key.
        case `return` = "\r"
    }

    /// Specifies a simple string as the content of the button.
    public private(set) var title: String? = nil

    /// Specifies an attributed string as the content of the button.
    public private(set) var attributedTitle: NSAttributedString? = nil

    /// Specifies an image as the content of the button. Note that the appearance of the image may be
    /// modified if `autoInvertImage` is specified.
    public private(set) var image: NSImage? = nil

    /// Specifies a keyboard equivalent to pressing the button.
    public var keyEquivalent: KeyEquivalent? = nil

    /// Specifies the type of the button.
    public var buttonType: NSButton.ButtonType? = nil

    /// Specifies an alternate image to be displayed when the button is activated. Note that the appearance
    /// of the image may be modified if `autoInvertImage` is specified.
    @available(*, deprecated, message: "Use nsButtonViewSettings.alternateImage")
    public var alternateImage: NSImage? { nsButtonViewSettings.alternateImage }

    /// Specifies type type of border.
    public var bezelStyle: NSButton.BezelStyle? = nil

    /// Allows the border to be turned on/off.
    @available(*, deprecated, message: "Use nsButtonViewSettings.isBordered")
    public var isBordered: Bool? { nsButtonViewSettings.isBordered }

    /// If set to true, and if `image` or `alternateImage` exist, they will have their colors automatically
    /// inverted when we are displaying in "dark mode". This is most useful if they are monochrome images.
    @available(*, deprecated, message: "Use nsButtonViewSettings.autoInvertImage")
    public var autoInvertImage: Bool { nsButtonViewSettings.autoInvertImage }

    /// Allows a tool tip to be displayed if the cursor hovers over the control for a few moments.
    @available(*, deprecated, message: "Use nsButtonViewSettings.toolTip")
    public var toolTip: String? { nsButtonViewSettings.toolTip }

    private let action: () -> Void

    /**
     Construct a button with a simple string.
     */
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    /**
     Construct a button with a simple string.
     */
    @available(*, deprecated, message: "Use init(_, action:) plus modifiers")
    public init(_ title: String,
                keyEquivalent: KeyEquivalent? = nil,
                buttonType: NSButton.ButtonType? = nil,
                bezelStyle: NSButton.BezelStyle? = nil,
                isBordered: Bool? = nil,
                toolTip: String? = nil,
                action: @escaping () -> Void)
    {
        self.init(title, action: action)
        self.keyEquivalent = keyEquivalent
        self.buttonType = buttonType
        self.bezelStyle = bezelStyle
        self.nsButtonViewSettings.isBordered = isBordered
        self.nsButtonViewSettings.toolTip = toolTip
    }

    /**
     Construct a button with an attributed string.
     */
    public init(withAttributedTitle attributedTitle: NSAttributedString, action: @escaping () -> Void) {
        self.attributedTitle = attributedTitle
        self.action = action
    }

    /**
     Construct a button with an attributed string.
     */
    @available(*, deprecated, message: "Use init(withAttributedTitle:, action:) plus modifiers")
    public init(withAttributedTitle attributedTitle: NSAttributedString,
                keyEquivalent: KeyEquivalent? = nil,
                buttonType: NSButton.ButtonType? = nil,
                bezelStyle: NSButton.BezelStyle? = nil,
                isBordered: Bool? = nil,
                toolTip: String? = nil,
                action: @escaping () -> Void)
    {
        self.init(withAttributedTitle: attributedTitle, action: action)
        self.keyEquivalent = keyEquivalent
        self.buttonType = buttonType
        self.bezelStyle = bezelStyle
        self.nsButtonViewSettings.isBordered = isBordered
        self.nsButtonViewSettings.toolTip = toolTip
    }

    /**
     Construct a button with an image.
     */
    public init(withImage image: NSImage, action: @escaping () -> Void) {
        self.image = image
        self.action = action
    }

    /**
     Construct a button with an image.
     */
    @available(*, deprecated, message: "Use init(withImage:, action:) plus modifiers")
    public init(withImage image: NSImage,
                alternateImage: NSImage? = nil,
                autoInvertImage: Bool = true,
                keyEquivalent: KeyEquivalent? = nil,
                buttonType: NSButton.ButtonType? = nil,
                bezelStyle: NSButton.BezelStyle? = nil,
                isBordered: Bool? = nil,
                toolTip: String? = nil,
                action: @escaping () -> Void)
    {
        self.init(withImage: image, action: action)
        self.nsButtonViewSettings.alternateImage = alternateImage
        self.nsButtonViewSettings.autoInvertImage = autoInvertImage
        self.keyEquivalent = keyEquivalent
        self.buttonType = buttonType
        self.bezelStyle = bezelStyle
        self.nsButtonViewSettings.isBordered = isBordered
        self.nsButtonViewSettings.toolTip = toolTip
    }

    /// :nodoc:
    public func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = commonMakeButton(context: context)
        button.onAction { _ in self.action() }
        if let keyEquivalent = keyEquivalent {
            button.keyEquivalent = keyEquivalent.rawValue
        }
        return button
    }

    /// :nodoc:
    public func updateNSView(_ button: NSButton, context: NSViewRepresentableContext<Self>) {
        DispatchQueue.main.async {
            self.commonUpdateButton(button, context: context)
        }
    }
}

// MARK: KSSNativeButton View Modifiers

@available(OSX 10.15, *)
public extension NSViewRepresentable {
    /**
     Sets a key equivalent trigger for the button.
     - note: If the view is not a `KSSNativeButton` view, then a warning will be logged and no change made.
     */
    func nsKeyEquivalent(_ keyEquivalent: KSSNativeButton.KeyEquivalent) -> Self {
        if var buttonView = self as? KSSNativeButton {
            buttonView.keyEquivalent = keyEquivalent
            return buttonView as! Self
        } else {
            os_log("Warning: View is not a KSSNativeButton, ignoring key equivalent change")
        }
        return self
    }

    /**
     Sets the button type.
     - note: If the view is not a `KSSNativeButton` view, then a warning will be logged and no change made.
     */
    func nsButtonType(_ buttonType: NSButton.ButtonType) -> Self {
        if var buttonView = self as? KSSNativeButton {
            buttonView.buttonType = buttonType
            return buttonView as! Self
        } else {
            os_log("Warning: View is not a KSSNativeButton, ignoring button type change")
        }
        return self
    }

    /**
     Sets the bezel style.
     - note: If the view is not a `KSSNativeButton` view, then a warning will be logged and no change made.
     */
    func nsBezelStyle(_ bezelStyle: NSButton.BezelStyle) -> Self {
        if var buttonView = self as? KSSNativeButton {
            buttonView.bezelStyle = bezelStyle
            return buttonView as! Self
        } else {
            os_log("Warning: View is not a KSSNativeButton, ignoring bezel style change")
        }
        return self
    }
}


// The following are helper items used to reduce the amount of repeated code between
// the various KSS "native" buttons.
@available(OSX 10.15, *)
protocol KSSNativeButtonCommonHelper : KSSNSButtonViewSettable {
    var title: String? { get }
    var attributedTitle: NSAttributedString? { get }
    var image: NSImage? { get }

    var buttonType: NSButton.ButtonType? { get }
    var bezelStyle: NSButton.BezelStyle? { get }
}

/// :nodoc:
@available(OSX 10.15, *)
extension KSSNativeButtonCommonHelper {
    func commonMakeButton<View : NSViewRepresentable>(context: NSViewRepresentableContext<View>) -> NSButton
        where View.NSViewType : NSButton
    {
        let button = NSButton(title: "", target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        if let attributedTitle = attributedTitle {
            button.attributedTitle = attributedTitle
        } else if let title = title {
            button.title = title
        } else if image != nil {
            // Intentionally empty. Since the choise of image is dependant on the
            // colorScheme, which may change, we delay the setting of the image
            // until the commonUpdateButton call.
        } else {
            fatalError("One of 'title', 'attributedTitle' or 'image' is required")
        }

        if let buttonType = buttonType {
            button.setButtonType(buttonType)
        }

        if let bezelStyle = bezelStyle {
            button.bezelStyle = bezelStyle
        }

        _ = applyNSButtonViewSettings(button as! View.NSViewType, context: context)
        return button
    }


    func commonUpdateButton<View : NSViewRepresentable>(_ button: NSButton,
                                                        context: NSViewRepresentableContext<View>)
        where View.NSViewType : NSButton
    {
        _ = applyNSButtonViewSettings(button as! View.NSViewType, context: context)
        let colorScheme = context.environment.colorScheme
        let shouldInvert = nsButtonViewSettings.autoInvertImage && (colorScheme == .dark)
        if let image = image {
            button.image = shouldInvert ? image.inverted() : image
        }
        if let alternateImage = nsButtonViewSettings.alternateImage {
            button.alternateImage = shouldInvert ? alternateImage.inverted() : alternateImage
        }
    }
}

// The following is the "glue" needed to allow the button action to be set (since
// the NSButton selector needs to be an Objective-C object).
fileprivate var controlActionClosureProtocolAssociatedObjectKey: UInt8 = 0

fileprivate final class ActionTrampoline<T>: NSObject {
    public let action: (T) -> Void

    public init(action: @escaping (T) -> Void) {
        self.action = action
    }

    @objc
    public func action(sender: AnyObject) {
        action(sender as! T)
    }
}

/// :nodoc:
protocol KSSNativeButtonControlActionClosureProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

/// :nodoc:
extension KSSNativeButtonControlActionClosureProtocol {
    func onAction(_ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        self.target = trampoline
        self.action = #selector(ActionTrampoline<Self>.action(sender:))
        objc_setAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
    }
}

/// :nodoc:
extension NSControl: KSSNativeButtonControlActionClosureProtocol {}

#else

// Force the compiler to give us a more descriptive error message.
@available(iOS, unavailable)
public struct KSSNativeButton {}

#endif
