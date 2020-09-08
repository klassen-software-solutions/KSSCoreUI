//
//  KSSSearchFieldTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-08-05.
//

#if canImport(Cocoa)

import Foundation
import KSSTest
import SwiftUI
import XCTest

@testable import KSSSwiftUI


@available(OSX 10.15, *)
class KSSSearchFieldTests: XCTestCase {
    struct TestThatItCompilesInAView : View {
        var body: some View {
            VStack {
                KSSSearchField()
                KSSSearchField(helpText: "help", recentSearchesKey: "recentKey") { _ in print("hi") }
                    .nsFont(NSFont.systemFont(ofSize: 10))
                    .nsFontSize(12)
            }
        }
    }

    func testConstruction() {
        var control = KSSSearchField()
        assertEqual(to: "") { control.helpText }
        assertEqual(to: "") { control.recentSearchesKey }
        assertFalse { control.isFilterField }
        assertNil { control.searchCallback }

        control = KSSSearchField(helpText: "help", recentSearchesKey: "recents") { _ in }
        assertEqual(to: "help") { control.helpText }
        assertEqual(to: "recents") { control.recentSearchesKey }
        assertFalse { control.isFilterField }
        assertNotNil { control.searchCallback }

        control = KSSSearchField(isFilterField: true)
        assertEqual(to: "") { control.helpText }
        assertEqual(to: "") { control.recentSearchesKey }
        assertTrue { control.isFilterField }
        assertNil { control.searchCallback }
    }

    func testNSCommandModifiers() {
        var control = KSSSearchField()
        assertNil { control.nsControlViewSettings.font }
        assertNil { control.nsControlViewSettings.fontSize }

        control = control.nsFont(NSFont.boldSystemFont(ofSize: 10))
        assertNotNil { control.nsControlViewSettings.font }
        assertNil { control.nsControlViewSettings.fontSize }

        control = control.nsFontSize(10)
        assertNotNil { control.nsControlViewSettings.font }
        assertEqual(to: 10) { control.nsControlViewSettings.fontSize }
    }
}

#endif
