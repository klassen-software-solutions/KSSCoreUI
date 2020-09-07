//
//  KSSToggleTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-05.
//

#if canImport(Cocoa)

import Foundation
import KSSTest
import SwiftUI
import XCTest

import KSSSwiftUI


@available(OSX 10.15, *)
class KSSToggleTests : XCTestCase {
    struct TestThatItCompilesInAView : View {
        @State var isOn: Bool = true

        var body: some View {
            VStack {
                KSSToggle("button", isOn: $isOn)
                KSSToggle("button", isOn: $isOn, isBordered: true, toolTip: "hi")
                KSSToggle(withAttributedTitle: NSAttributedString(string: "button"),
                          isOn: $isOn,
                          isBordered: false,
                          toolTip: "hi")
                KSSToggle(withImage: NSImage(),
                          isOn: $isOn,
                          alternateImage: NSImage(),
                          autoInvertImage: false,
                          isBordered: false,
                          toolTip: "hi")
                    .nsFont(NSFont.systemFont(ofSize: 10))
                    .nsFontSize(12)
            }
        }
    }


    func testConstruction() {
        var button = KSSToggle("button", isOn: .constant(true))
        assertEqual(to: "button") { button.title }
        XCTAssertNil(button.attributedTitle)
        XCTAssertNil(button.image)

        button = KSSToggle("button",
                           isOn: .constant(true),
                           isBordered: false,
                           toolTip: "this is a tooltip")
        assertEqual(to: "button") { button.title }
        XCTAssertNil(button.attributedTitle)
        XCTAssertNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertFalse(button.isBordered!)
        assertEqual(to: "this is a tooltip") { button.toolTip }
        XCTAssertTrue(button.autoInvertImage)

        button = KSSToggle(withAttributedTitle: NSAttributedString(string: "button"), isOn: .constant(true))
         XCTAssertNil(button.title)
        assertEqual(to:  NSAttributedString(string: "button")) { button.attributedTitle }
         XCTAssertNil(button.image)

        button = KSSToggle(withAttributedTitle: NSAttributedString(string: "button"),
                           isOn: .constant(true),
                           isBordered: false,
                           toolTip: "this is a tooltip")
        XCTAssertNil(button.title)
        XCTAssertEqual(button.attributedTitle, NSAttributedString(string: "button"))
        XCTAssertNil(button.image)
        XCTAssertNil(button.alternateImage)
        XCTAssertFalse(button.isBordered!)
        XCTAssertEqual(button.toolTip, "this is a tooltip")
        XCTAssertTrue(button.autoInvertImage)

        button = KSSToggle(withImage: NSImage(), isOn: .constant(true))
        assertNil { button.title }
        assertNil { button.attributedTitle }
        assertNotNil { button.image }

        button = KSSToggle(withImage: NSImage(),
                           isOn: .constant(true),
                           alternateImage: NSImage(),
                           autoInvertImage: false,
                           isBordered: false,
                           toolTip: "this is a tooltip")
        XCTAssertNil(button.title)
        XCTAssertNil(button.attributedTitle)
        XCTAssertNotNil(button.image)
        XCTAssertNotNil(button.alternateImage)
        XCTAssertFalse(button.isBordered!)
        XCTAssertEqual(button.toolTip, "this is a tooltip")
        XCTAssertFalse(button.autoInvertImage)
    }

    func testNSCommandModifiers() {
        var button = KSSToggle("button", isOn: .constant(true))
        assertNil { button.nsControlViewSettings.font }
        assertNil { button.nsControlViewSettings.fontSize }

        button = button.nsFont(NSFont.boldSystemFont(ofSize: 10))
        assertNotNil { button.nsControlViewSettings.font }
        assertNil { button.nsControlViewSettings.fontSize }

        button = button.nsFontSize(10)
        assertNotNil { button.nsControlViewSettings.font }
        assertEqual(to: 10) { button.nsControlViewSettings.fontSize }
    }

    func testNSButtonModifiers() {
        var button = KSSToggle("button", isOn: .constant(true))
        assertNil { button.nsButtonViewSettings.alternateImage }
        assertTrue { button.nsButtonViewSettings.autoInvertImage }
        assertNil { button.nsButtonViewSettings.isBordered }
        assertNil { button.nsButtonViewSettings.showsBorderOnlyWhileMouseInside }
        assertNil { button.nsButtonViewSettings.toolTip }

        button = button.nsAlternateImage(NSImage())
            .nsAutoInvertImage(false)
            .nsIsBordered(true)
            .nsShowsBorderOnlyWhileMouseInside(true)
            .nsToolTip("tooltip")
        assertNotNil { button.nsButtonViewSettings.alternateImage }
        assertFalse { button.nsButtonViewSettings.autoInvertImage }
        assertTrue { button.nsButtonViewSettings.isBordered! }
        assertTrue { button.nsButtonViewSettings.showsBorderOnlyWhileMouseInside! }
        assertEqual(to: "tooltip") { button.nsButtonViewSettings.toolTip }
    }
}

#endif
