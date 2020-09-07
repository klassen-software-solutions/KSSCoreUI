//
//  NSColorExtension.swift
//  HTTPMonitor
//
//  Created by Steven W. Klassen on 2020-08-13.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//  Released under the MIT license.
//

#if canImport(Cocoa)

import Cocoa
import Foundation


public extension NSColor {
    /// Specifies the color to be used for highlighting errors. Typically this would be used as a background,
    /// but it can also be used as a foreground color if you add `.withAlphaComponent(1)` to make
    /// it stand out better.
    class var errorHighlightColor: NSColor { NSColor.systemYellow.withAlphaComponent(0.50) }
}

#endif
