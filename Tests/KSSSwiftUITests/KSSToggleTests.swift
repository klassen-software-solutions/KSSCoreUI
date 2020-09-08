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
                    .toolTip("hello world")
            }
        }
    }


    func testConstruction() {
        var button = KSSToggle("button", isOn: .constant(true))
        assertEqual(to: "button") { button.title }
        XCTAssertNil(button.attributedTitle)
        XCTAssertNil(button.image)

        button = KSSToggle(withAttributedTitle: NSAttributedString(string: "button"), isOn: .constant(true))
         XCTAssertNil(button.title)
        assertEqual(to:  NSAttributedString(string: "button")) { button.attributedTitle }
         XCTAssertNil(button.image)

        button = KSSToggle(withImage: NSImage(), isOn: .constant(true))
        assertNil { button.title }
        assertNil { button.attributedTitle }
        assertNotNil { button.image }
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

        button = button.nsAlternateImage(NSImage())
            .nsAutoInvertImage(false)
            .nsIsBordered(true)
            .nsShowsBorderOnlyWhileMouseInside(true)
        assertNotNil { button.nsButtonViewSettings.alternateImage }
        assertFalse { button.nsButtonViewSettings.autoInvertImage }
        assertTrue { button.nsButtonViewSettings.isBordered! }
        assertTrue { button.nsButtonViewSettings.showsBorderOnlyWhileMouseInside! }
    }
}

#endif
