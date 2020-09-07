//
//  KSSSearchField.swift
//
//  Created by Steven W. Klassen on 2020-07-31.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import Cocoa
import SwiftUI

/**
 Provides a SwiftUI view based on an NSSearchField.
 */
@available(OSX 10.15, *)
@available(iOS, unavailable)
public struct KSSSearchField: NSViewRepresentable, KSSNSControlViewSettable {
    /// Settings applicable to all KSS `NSControl` based Views.
    public var nsControlViewSettings = KSSNSControlViewSettings()

    /// Type used for the search callback.
    public typealias Callback = (String?)->Void

    /// :nodoc:
    public let helpText: String

    /// :nodoc:
    public let recentSearchesKey: String

    /// :nodoc:
    public let isFilterField: Bool

    /// :nodoc:
    public let searchCallback: Callback?

    /**
     Create a search field. The field is essentially a text field where the user can type a search, an optional
     menu that provides a list of the most recent searches, and a cancel button that is used to stop the
     search.

     - parameters:
     - helpText: A short text that will be displayed in the search field when it is empty.
     - recentSearchesKey: A user defaults key for storing the recent searches.
     - isFilterField: If true then a filter icon instead of the search icon will be used.
     - searchCallback: A lambda that will be called when it is time to search.
     */
    public init(helpText: String = "",
                recentSearchesKey: String = "",
                isFilterField: Bool = false,
                _ searchCallback: Callback? = nil)
    {
        self.helpText = helpText
        self.recentSearchesKey = recentSearchesKey
        self.isFilterField = isFilterField
        self.searchCallback = searchCallback
    }

    // MARK: NSViewRepresentable Items

    /// :nodoc:  Required part of the `NSViewRepresentable` protocol.
    public typealias NSViewType = NSSearchField

    /// :nodoc:  Required part of the `NSViewRepresentable` protocol.
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    /// :nodoc:  Required part of the `NSViewRepresentable` protocol.
    public func makeNSView(context: Context) -> NSSearchField {
        let searchField = NSSearchField()
        searchField.sendsSearchStringImmediately = false
        if !helpText.isEmpty {
            searchField.placeholderString = helpText
        }
        if !recentSearchesKey.isEmpty {
            searchField.recentsAutosaveName = recentSearchesKey
            searchField.maximumRecents = 5
            searchField.addRecentsMenu()
        }
        if isFilterField {
            searchField.setupAsFilterField(includeMenu: !recentSearchesKey.isEmpty)
        }
        searchField.delegate = context.coordinator
        _ = applyNSControlViewSettings(searchField, context: context)
        return searchField
    }

    /// :nodoc:  Required part of the `NSViewRepresentable` protocol.
    public func updateNSView(_ searchField: NSSearchField, context: Context) {
        DispatchQueue.main.async {
            if let window = searchField.window {
                searchField.cell?.isEnabled = window.isKeyWindow
            }
            _ = self.applyNSControlViewSettings(searchField, context: context)
        }
    }
}


@available(OSX 10.14, *)
fileprivate extension NSSearchField {
    func setupAsFilterField(includeMenu: Bool) {
        if let searchFieldCell = self.cell as? NSSearchFieldCell {
            if let searchButtonCell = searchFieldCell.searchButtonCell {
                let size = searchButtonCell.image!.size
                searchButtonCell.image = getFilterImage(ofSize: size, includeMenu: includeMenu)

                DistributedNotificationCenter.default().addObserver(
                    self,
                    selector: #selector(self.onThemeChanged(notification:)),
                    name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"),
                    object: nil)
            }
        }
    }

    func getFilterImage(ofSize size: NSSize, includeMenu: Bool) -> NSImage {
        // The constants found here result in an image size and spacing that is similar
        // to that of the magnifying glass icon.
        let height = min(size.width, size.height) - (includeMenu ? 10 : 8)
        let width = height + (includeMenu ? 5 : 0)
        let newSize = CGSize(width: width, height: height)
        let imageStream = includeMenu
            ? filterIconWithMenuInputStream()
            : filterIconWithoutMenuInputStream()
        var image = NSImage(fromInputStream: imageStream)!
        image = image.resized(to: newSize)!
        if NSApplication.shared.isDarkMode {
            image = image.inverted()
        }
        return image
    }

    @available(OSX 10.14, *)
    @objc func onThemeChanged(notification: NSNotification) {
        if let searchFieldCell = self.cell as? NSSearchFieldCell {
            if let searchButtonCell = searchFieldCell.searchButtonCell {
                searchButtonCell.image = searchButtonCell.image?.inverted()
            }
        }
    }

    func addRecentsMenu() {
        let cellMenu = NSMenu(title: "Search Menu")
        cellMenu.addItem(withTitle: "Recents", andTag: NSSearchField.recentsMenuItemTag)
        cellMenu.addItem(NSMenuItem.separator())
        cellMenu.addItem(withTitle: "Clear History", andTag: NSSearchField.clearRecentsMenuItemTag)
        self.searchMenuTemplate = cellMenu
    }
}

fileprivate extension NSMenu {
    func addItem(withTitle title: String, andTag tag: Int) {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.tag = tag
        self.addItem(item)
    }
}

/// :nodoc:  Required part of the `NSViewRepresentable` protocol.
@available(OSX 10.15, *)
extension KSSSearchField {
    public class Coordinator: NSObject, NSSearchFieldDelegate, NSTextFieldDelegate {
        let owner: KSSSearchField
        var isSearching = false

        init(_ owner: KSSSearchField) {
            self.owner = owner
        }

        public func searchFieldDidStartSearching(_ sender: NSSearchField) {
            isSearching = true
            performSearch(basedOn: sender)
        }

        public func searchFieldDidEndSearching(_ sender: NSSearchField) {
            isSearching = false
            owner.searchCallback?(nil)
        }

        public func controlTextDidChange(_ obj: Notification) {
            if isSearching {
                if let sender = obj.object as? NSSearchField {
                    performSearch(basedOn: sender)
                }
            }
        }

        private func performSearch(basedOn searchField: NSSearchField) {
            if let lambda = owner.searchCallback {
                let searchText = searchField.stringValue
                let haveSearchText = isSearching && !searchText.isEmpty
                lambda(haveSearchText ? searchText : nil)
            }
        }
    }
}

#else

// Force the compiler to give us a more descriptive error message.
@available(iOS, unavailable)
public struct KSSSearchField {}

#endif
