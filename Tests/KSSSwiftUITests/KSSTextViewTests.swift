//
//  KSSTextViewTests.swift
//  
//
//  Created by Steven W. Klassen on 2020-03-16.
//

#if canImport(Cocoa)

import SwiftUI
import KSSTest
import XCTest

import KSSSwiftUI


@available(OSX 10.15, *)
class KSSTextViewTests: XCTestCase {
    @State private var testMutableAttributedString = NSMutableAttributedString()

    func testConstruction() {
        var view = KSSTextView(text: $testMutableAttributedString)
        assertTrue { view.isEditable }
        assertTrue { view.isSearchable }
        assertFalse { view.isAutoScrollToBottom }

        view = KSSTextView(text: $testMutableAttributedString)
            .editable(false)
            .searchable(false)
            .autoScrollToBottom()
        assertFalse { view.isEditable }
        assertFalse { view.isSearchable }
        assertTrue { view.isAutoScrollToBottom }
    }
}

#endif
