//
//  NSMenuExtension.swift
//  WSTerminal
//
//  Created by Steven W. Klassen on 2020-02-14.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//  Released under the MIT license.
//

#if canImport(Cocoa)

import Cocoa

public extension NSMenu {

    /**
     Performs a deep search of the menu for a menu item with the given tag.

     - returns:
     The first item that has the requested tag or nil if no such item could be found.
     */
    @available(*, deprecated, message: "Use item(withTag:) instead")
    func findMenuItem(withTag tag: Int) -> NSMenuItem? {
        for item in self.items {
            if !item.isSeparatorItem {
                if item.tag == tag {
                    return item
                }
                if let submenu = item.submenu {
                    if let subitem = submenu.findMenuItem(withTag: tag) {
                        return subitem
                    }
                }
            }
        }
        return nil
    }
}

#endif
