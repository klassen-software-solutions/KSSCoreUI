//
//  KSSURLTextFieldTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-05.
//  Released under the MIT license.
//

import Foundation
import SwiftUI
import XCTest

@testable import KSSSwiftUI


@available(OSX 10.15, *)
class KSSURLTextFieldTests: XCTestCase {
    struct TestThatItCompilesInAView : View {
        @State var url: URL? = nil

        var body: some View {
            VStack {
                KSSURLTextField(url: $url)
                KSSURLTextField(url: $url, helpText: "help")
                    .errorHighlight(Color.green)
                    .validator { _ in return false }
            }
        }
    }


    func testConstruction() {
        // TODO: make this more general, just check against Color.errorHighligthColor if possible
#if canImport(Cocoa)
        let correctColor = Color(NSColor.errorHighlightColor)
#else
        let correctColor = Color.yellow.opacity(0.5)
#endif

        var control = KSSURLTextField(url: .constant(nil))
        assertEqual(to: "url") { control.helpText }
        assertNil { control.validatorFn }
        assertEqual(to: correctColor) { control.errorHighlightColor }

        control = KSSURLTextField(url: .constant(nil), helpText: "help")
        assertEqual(to: "help") { control.helpText }
        assertNil { control.validatorFn }
        assertEqual(to: correctColor) { control.errorHighlightColor }
    }

    func testModifiers() {
        let control = KSSURLTextField(url: .constant(nil))
            .errorHighlight(Color.red)
            .validator { _ in return true }
        assertEqual(to: Color.red) { control.errorHighlightColor }
        assertNotNil { control.validatorFn }
    }
}
