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

#if canImport(Cocoa)
@available(OSX 10.15, *)
fileprivate let errorHighlightColor = Color(NSColor.errorHighlightColor)
#else
// TODO: replace this with a more general solution
fileprivate let errorHighlightColor = Color.yellow.opacity(0.5)
#endif

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
