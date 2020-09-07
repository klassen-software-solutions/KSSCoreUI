//
//  KSSCommandTextFieldTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-05.
//  Released under the MIT license.
//

#if canImport(Cocoa)

import Foundation
import KSSTest
import SwiftUI
import XCTest

@testable import KSSSwiftUI


@available(OSX 10.15, *)
class KSSCommandTextFieldTests: XCTestCase {
    struct TestThatItCompilesInAView : View {
        @State private var command: String = ""

        var body: some View {
            VStack {
                KSSCommandTextField(command: $command)
                KSSCommandTextField(command: $command, helpText: "message to send")
                    .errorHighlight(NSColor.green)
                    .validator { _ in return false }
                    .nsFont(NSFont.systemFont(ofSize: 10))
                    .nsFontSize(12)
            }
        }
    }


    func testConstruction() {
        var commandField = KSSCommandTextField(command: .constant("hi"))
        assertEqual(to: "hi") { commandField.command }
        assertEqual(to: "command") { commandField.helpText }
        assertNil { commandField.validatorFn }
        assertEqual(to: NSColor.errorHighlightColor) { commandField.errorHighlightColor }

        commandField = KSSCommandTextField(command: .constant("hi"), helpText: "help")
        assertEqual(to: "hi") { commandField.command }
        assertEqual(to: "help") { commandField.helpText }
        assertNil { commandField.validatorFn }
        assertEqual(to: NSColor.errorHighlightColor) { commandField.errorHighlightColor }
    }

    func testModifiers() {
        let commandField = KSSCommandTextField(command: .constant("hi"))
            .errorHighlight(NSColor.red)
            .validator { _ in return true }
        assertEqual(to: NSColor.red) { commandField.errorHighlightColor }
        assertNotNil { commandField.validatorFn }
    }

    func testNSCommandModifiers() {
        var commandField = KSSCommandTextField(command: .constant("hi"))
        assertNil { commandField.nsControlViewSettings.font }
        assertNil { commandField.nsControlViewSettings.fontSize }

        commandField = commandField.nsFont(NSFont.boldSystemFont(ofSize: 10))
        assertNotNil { commandField.nsControlViewSettings.font }
        assertNil { commandField.nsControlViewSettings.fontSize }

        commandField = commandField.nsFontSize(10)
        assertNotNil { commandField.nsControlViewSettings.font }
        assertEqual(to: 10) { commandField.nsControlViewSettings.fontSize }
    }
}

#endif
