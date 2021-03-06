//
//  KSSNativeButtonTests.swift
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
class KSSNativeButtonTests: XCTestCase {
    struct TestThatItCompilesInAView : View {
        var body: some View {
            VStack {
                KSSNativeButton("button 1") { print("button 1") }
                KSSNativeButton("button 3") { print("button 3") }
                    .nsFont(NSFont.systemFont(ofSize: 10))
                    .nsFontSize(12)
                    .nsIsBordered(true)
                    .toolTip("this is a tooltip")
            }
        }
    }


    func testConstruction() {
        var button = KSSNativeButton("button") { print("hi") }
        assertEqual(to: "button") { button.title }
        assertNil { button.attributedTitle }
        assertNil { button.image }
        assertNil { button.keyEquivalent }
        assertNil { button.buttonType }
        assertNil { button.bezelStyle }

        button = KSSNativeButton(withAttributedTitle: NSAttributedString(string: "button")) { print("hi") }
        assertNil { button.title }
        assertEqual(to: NSAttributedString(string: "button")) { button.attributedTitle }
        assertNil { button.image }
        assertNil { button.keyEquivalent }
        assertNil { button.buttonType }
        assertNil { button.bezelStyle }

        button = KSSNativeButton(withImage: NSImage()) { print("hi") }
        assertNil { button.title }
        assertNil { button.attributedTitle }
        assertNotNil { button.image }
        assertNil { button.keyEquivalent }
        assertNil { button.buttonType }
        assertNil { button.bezelStyle }
    }

    func testNSCommandModifiers() {
        var button = KSSNativeButton("button") { print("hi") }
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
        var button = KSSNativeButton("button") { print("hi") }
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

    func testKSSNativeButtonModifiers() {
        var button = KSSNativeButton("button") { print("hi") }
        assertNil { button.keyEquivalent }
        assertNil { button.buttonType }
        assertNil { button.bezelStyle }

        button = button.nsKeyEquivalent(.escape)
            .nsButtonType(.momentaryLight)
            .nsBezelStyle(.disclosure)
        assertEqual(to: .escape) { button.keyEquivalent }
        assertEqual(to: .momentaryLight) { button.buttonType }
        assertEqual(to: .disclosure) { button.bezelStyle }
    }
}

#endif
