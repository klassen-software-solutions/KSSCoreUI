//
//  Created by Steven W. Klassen on 2020-06-18.
//

#if canImport(Cocoa)

import SwiftUI
import XCTest

import KSSWeb

@available(OSX 10.15.0, *)
fileprivate struct MyView: View {
    @State private var url: URL? = nil
    @State private var url2 = URL(string: "http://hello.not.there/")!
    @State private var testBool: Bool = true

    var body: some View {
        VStack {
            KSSWebView(url: $url2)
        }
    }
}

class KSSWebConstructorTests: XCTestCase {
    func testObjectWillCompile() {
        // Intentionally empty. This file tests that the UI controls can be included
        // in a view. It is a compile, not a runtime, test.
    }
}

#endif
