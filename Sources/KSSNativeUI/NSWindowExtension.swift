//
//  NSWindowExtension.swift
//  WSTerminal
//
//  Created by Steven W. Klassen on 2020-02-24.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import os
import Cocoa

public extension NSWindow {
    /**
     Force the tab bar to become visible if possible.
     */
    @available(OSX 10.13, *)
    func turnOnTabBar(_ sender: Any? = nil) {
        if let group = self.tabGroup {
            if !group.isTabBarVisible {
                self.toggleTabBar(sender)
            }
        }
    }

    /**
     Force the tab bar to become invisible if possible.
     */
    @available(OSX 10.14, *)
    func turnOffTabBar(_ sender: Any?) {
        if let group = self.tabGroup {
            if group.isTabBarVisible {
                self.toggleTabBar(sender)

                // If we are the only item in the tab group, then toggling the bar is
                // not sufficient, we also need to remove ourselves from the group.
                if self.tabbedWindows?.count == 1 {
                    os_log(.debug, "Forcing off TabBar by removing us from the group")
                    group.removeWindow(self)
                }
            }
        }
    }
}

#endif
