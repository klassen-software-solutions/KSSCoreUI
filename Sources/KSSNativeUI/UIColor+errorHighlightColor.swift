//
//  UIColor+errorHighlightColor.swift
//  
//
//  Created by Steven W. Klassen on 2020-09-07.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
    /// Specifies the color to be used for highlighting errors. Typically this would be used as a background,
    /// but it can also be used as a foreground color if you add `.withAlphaComponent(1)` to make
    /// it stand out better.
    class var errorHighlightColor: UIColor { UIColor.systemYellow.withAlphaComponent(0.50) }
}

#endif
