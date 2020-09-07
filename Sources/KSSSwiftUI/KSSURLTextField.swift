//
//  KSSURLTextField.swift
//
//  Created by Steven W. Klassen on 2020-01-16.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//  Released under the MIT license.
//

#if canImport(Cocoa)
import Cocoa
#endif

import Combine
import SwiftUI

/**
 Provides a text field used to enter a URL.
 */
@available(OSX 10.15, *)
public struct KSSURLTextField: View, KSSValidatingView {
    /**
     A binding to the URL to be updated. Note that setting this only sets the initial value of the field when it
     is created. To change the URL from an outside source you must provide it with a publisher using the
     `urlPublisher` modifier.
     */
    @Binding public var url: URL?

    /**
     The help text to be displayed in the field when it is empty.
     */
    public let helpText: String

    static private var nilUrlPublisher = PassthroughSubject<URL?, Never>().eraseToAnyPublisher()
    private var _urlPublisher: AnyPublisher<URL?, Never> = KSSURLTextField.nilUrlPublisher

    @State private var errorState: Bool = false
    @State private var text: String = ""

    /**
     Construct a text field with the given url binding and help text.
     */
    public init(url: Binding<URL?>, helpText: String = "url") {
        self._url = url
        self.helpText = helpText
    }

    /// :nodoc:
    public var body: some View {
        TextField(helpText, text: $text, onCommit: { self.updateUrl() })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(errorState ? self.errorHighlightColor : nil)
            .onAppear { self.text = self.url?.absoluteString ?? "" }
            .onReceive(_urlPublisher, perform: { url in
                self.text = url?.absoluteString ?? ""
                self.updateUrl()
            })
    }

    /**
     This modifier returns a view that will listen to the given publisher for URL changes. When the publisher
     sends a message, that url will be set into the field. The main use case for this is to allow a recent history
     menu to populate the control, and is necessary since setting the url binding does not actually set the
     url into the underlying control. Hence another means had to be provided.
     */
    public func urlPublisher(_ publisher: AnyPublisher<URL?, Never>) -> Self {
        var newView = self
        newView._urlPublisher = publisher
        return newView
    }

    private func validatedURL() -> URL? {
        if let u = URL(string: text) {
            if let fn = validatorFn {
                if fn(u) {
                    return u
                }
            } else {
                return u
            }
        }
        return nil
    }

    private func updateUrl() {
        if let u = validatedURL() {
            url = u
            errorState = false
        } else if text.isEmpty {
            url = nil
            errorState = false
        } else {
            errorState = true
        }
    }

    // MARK: KSSValidatingView Items

    /// :nodoc:
#if canImport(Cocoa)
    public var errorHighlightColor: Color = Color(NSColor.errorHighlightColor)
#else
    public var errorHighlightColor: Color = Color.yellow.opacity(0.5)
#endif

    /// :nodoc:
    public var validatorFn: ((URL) -> Bool)? = nil
}
