//
//  ViewExtensionTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-09-07.
//

import SwiftUI
import XCTest

import KSSSwiftUI


@available(OSX 10.15, *)
class ViewExtensionTests: XCTestCase {
    func testExtensionConstruction() {
        // Note that this is just a compile test. We don't have any way at present
        // of actually checking the results.
        _ = Text("hi")
            .visible(true)
            .invertColorIf(false)
            .errorStateIf(false)

        #if canImport(Cocoa)
        _ = Text("hi")
            .toolTip("hello world")
        #endif
    }
}
