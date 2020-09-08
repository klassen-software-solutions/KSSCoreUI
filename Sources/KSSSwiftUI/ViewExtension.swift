//
//  ViewExtension.swift
//  WSTerminal
//
//  Created by Steven W. Klassen on 2020-01-23.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//  Released under the MIT license.
//

import Foundation
import SwiftUI

#if canImport(Cocoa)
import Cocoa
#endif

@available(OSX 10.15, *)
public extension View {
    /**
     Returns a view that is visible or not visible based on `isVisible`.
     */
    func visible(_ isVisible: Bool) -> some View {
        modifier(VisibleModifier(isVisible: isVisible))
    }

    /**
     Returns a view that inverts its color if `shouldInvert` is true.
     */
    func invertColorIf(_ shouldInvert: Bool) -> some View {
        modifier(InvertColorIfModifier(shouldInvert: shouldInvert))
    }

    /**
     Returns a view that species an error state if `isInErrorState` is true. Note that presently
     the error state is indicated by changing the background color to be a yellow.
     */
    func errorStateIf(_ isInErrorState: Bool) -> some View {
        modifier(ErrorStateIfModifier(isInErrorState: isInErrorState))
    }

    #if canImport(Cocoa)
    /**
     Adds a tooltip to a view. The tooltip message will popup when the user hovers over the view for a period.
     */
    @available(iOS, unavailable)
    func toolTip(_ message: String) -> some View {
        return overlay(ToolTip(message: message))
    }
    #endif
}


@available(OSX 10.15, *)
fileprivate struct VisibleModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        Group {
            if isVisible {
                content
            } else {
                EmptyView()
            }
        }
    }
}

@available(OSX 10.15, *)
fileprivate struct InvertColorIfModifier: ViewModifier {
    let shouldInvert: Bool
    
    func body(content: Content) -> some View {
        Group {
            if shouldInvert {
                content.colorInvert()
            } else {
                content
            }
        }
    }
}

@available(OSX 10.15, *)
fileprivate let errorHighlightColor = Color.errorHighlightColor

@available(OSX 10.15, *)
fileprivate struct ErrorStateIfModifier: ViewModifier {
    let isInErrorState: Bool

    func body(content: Content) -> some View {
        Group {
            if isInErrorState {
                content.background(errorHighlightColor)
            } else {
                content
            }
        }
    }
}

#if canImport(Cocoa)
@available(OSX 10.15, *)
fileprivate struct ToolTip: NSViewRepresentable {
    let message: String

    func makeNSView(context: NSViewRepresentableContext<Self>) -> NSView {
        let view = NSView()
        view.toolTip = message
        return view
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<Self>) {
    }
}
#endif
