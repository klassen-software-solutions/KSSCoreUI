//
//  KSSCommandTextField.swift
//
//  Created by Steven W. Klassen on 2020-01-24.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//  Released under the MIT license.
//

#if canImport(Cocoa)

import Cocoa
import KSSNativeUI
import SwiftUI



/**
 TextField control suitable for entering command line type items.

 This control provides a SwiftUI View that can be used for command-like entries. It is implemented as a
 SwiftUI wrapper around a NSTextField control and allows for the following features.

 - Single line text entry,
 - Command line submission on pressing the `Return` or `Enter` keys,
 - Command line history accessed via the up and down arrow keys,
 - Optional validation of the input before submission,
 - Automatic highlighting of errors.
 */
@available(OSX 10.15, *)
@available(iOS, unavailable)
public struct KSSCommandTextField: NSViewRepresentable, KSSNSControlViewSettable, KSSValidatingView {
    /// Settings applicable to all KSS `NSControl` based Views.
    public var nsControlViewSettings = KSSNSControlViewSettings()

    /**
     Binding to the text of the current command. This will be updated when the user presses the `Return`
     or `Enter` keys.
     */
    @Binding public var command: String

    /**
     Help text to be displayed in the text field when it is empty.
     */
    public let helpText: String

    @State private var hasFocus = false
    @State private var history = CommandHistory()


    /**
     Construct a new text field with the given binding and help text.
     */
    public init(command: Binding<String>, helpText: String = "command") {
        self._command = command
        self.helpText = helpText
    }

    // MARK: Items for NSViewRepresentable

    /// :nodoc:
    public func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = helpText
        textField.delegate = context.coordinator
        textField.stringValue = command
        _ = applyNSControlViewSettings(textField, context: context)
        return textField
    }

    /// :nodoc:
    public func updateNSView(_ textField: NSTextField, context: Context) {
        DispatchQueue.main.async {
            _ = self.applyNSControlViewSettings(textField, context: context)
        }
    }

    // MARK: Items for KSSValidatingView


    /// :nodoc:
    public var validatorFn: ((String) -> Bool)? = nil

    /// :nodoc:
    public typealias ColorType = NSColor
    public var errorHighlightColor = ColorType.errorHighlightColor
}


@available(OSX 10.15, *)
extension KSSCommandTextField {
    /// :nodoc:
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// :nodoc:
    public class Coordinator: NSObject, NSTextFieldDelegate {
        let parent: KSSCommandTextField

        init(_ parent: KSSCommandTextField) {
            self.parent = parent
        }

        public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSTextView.insertNewline(_:)) {
                submitCommand(control, textView: textView)
            }
            else if commandSelector == #selector(NSTextView.moveUp(_:)) {
                previousInHistory(textView: textView)
            }
            else if commandSelector == #selector(NSTextView.moveDown(_:)) {
                nextInHistory(textView: textView)
            }

            return false
        }

        private func submitCommand(_ control: NSControl, textView: NSTextView) {
            let value = textView.string
            if let fn = parent.validatorFn {
                if !fn(value) {
                    parent.ensureBackgroundColorIs(parent.errorHighlightColor, for: control)
                    return
                }
            }
            parent.ensureBackgroundColorIs(nil, for: control)
            parent.command = value
            parent.history.addCommand(value)
        }

        private func previousInHistory(textView: NSTextView) {
            if let prev = parent.history.previous() {
                textView.string = prev
            }
        }

        private func nextInHistory(textView: NSTextView) {
            if let next = parent.history.next() {
                textView.string = next
            }
        }
    }

    // I don't like this. I would prefer having an "errorState" variable like I do with
    // the URLTextField class, and have updateNSView change the background color. However,
    // I cannot for the life of me get the NSTextField to redraw itself at the correct
    // time. If I could figure out how to get a SwiftUI TextField to respond to the
    // keypresses that I need, then I would drop NSTextField altogether. But I've spent
    // almost a week now trying to figure that out without success.
    private func ensureBackgroundColorIs(_ color: NSColor?, for control: NSControl) {
        if let textField = control as? NSTextField {
            textField.backgroundColor = color
        }
    }
}


private final class CommandHistory {
    let maximumHistoryLength: Int
    private var commands: [String] = []
    private var currentCommandPosition = -1

    init(maximumHistoryLength: Int = 1000) {
        precondition(maximumHistoryLength > 1, "A history must allow more than 1 item.")
        self.maximumHistoryLength = maximumHistoryLength
    }

    func addCommand(_ command: String) {
        precondition(isConsistent(), inconsistentStateMessage())
        let last = commands.last
        if !command.isEmpty && command != last {
            commands.append(command)
            while commands.count > maximumHistoryLength {
                _ = commands.remove(at: 0)
            }
            currentCommandPosition = commands.count - 1
        }
    }

    func next() -> String? {
        precondition(isConsistent(), inconsistentStateMessage())
        guard currentCommandPosition < commands.count - 1 else {
            return nil
        }
        currentCommandPosition += 1
        return commands[currentCommandPosition]
    }

    func previous() -> String? {
        precondition(isConsistent(), inconsistentStateMessage())
        guard currentCommandPosition > 0 else {
            return nil
        }
        currentCommandPosition -= 1
        return commands[currentCommandPosition]
    }

    private func isConsistent() -> Bool {
        if commands.count > maximumHistoryLength {
            return false
        }
        if commands.isEmpty {
            return currentCommandPosition == -1
        }
        return currentCommandPosition >= 0 && currentCommandPosition < commands.count
    }

    private func inconsistentStateMessage() -> String {
        return "inconsistent state: "
            + "maximumHistoryLength: \(maximumHistoryLength)"
            + ", currentCommandPosition: \(currentCommandPosition)"
            + ", commands: \(commands)"
    }
}

#else

// Force the compiler to give us a more descriptive error message.
@available(iOS, unavailable)
public struct KSSCommandTextField {}

#endif
