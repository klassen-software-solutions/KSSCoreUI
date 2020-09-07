//
//  Color+errorHighlightColor.swift
//  
//
//  Created by Steven W. Klassen on 2020-09-07.
//

import SwiftUI

#if canImport(Cocoa)
import Cocoa
#endif

#if canImport(UIKit)
import UIKit
#endif


@available(OSX 10.15, *)
public extension Color {
    /// Specifies the color to be used for highlighting errors. Typically this would be used as a background,
    /// but it can also be used as a foreground color if you add `.withAlphaComponent(1)` to make
    /// it stand out better.
    static var errorHighlightColor: Color {
        #if canImport(Cocoa)
        return Color(NSColor.errorHighlightColor)
        #elseif canImport(UIKit)
        return Color(UIColor.errorHighlightColor)
        #else
        return Color.yellow.opacity(0.5)
        #endif
    }
}
