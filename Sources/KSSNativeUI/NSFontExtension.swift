//
//  NSFontExtension.swift
//  WSTerminal
//
//  Created by Steven W. Klassen on 2020-02-11.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import Cocoa

public extension NSFont {

    /**
     Returns a font like the existing one but with the specified traits.

     - returns:
     The new font or nil if the conversion could not be made.
     */
    func withTraits(traits: NSFontDescriptor.SymbolicTraits) -> NSFont? {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return NSFont(descriptor: descriptor, size: 0)
    }

    /**
     Returns a new font like the existing one but converted to bold.
     */
    func bold() -> NSFont {
        return withTraits(traits: .bold)!
    }

    /**
     Returns a new font like the existing one but converted to italic.
     */
    func italic() -> NSFont {
        return withTraits(traits: .italic)!
    }
}

#endif
