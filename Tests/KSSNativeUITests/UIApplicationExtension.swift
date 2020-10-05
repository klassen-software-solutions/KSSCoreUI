#if canImport(UIKit)

import XCTest
import KSSTest

import KSSNativeUI

class UIApplicationExtensionTests: XCTestCase {
    func testMetadata() {
        assertEqual(to: "xctest") { UIApplication.shared.name }
        assertNil { UIApplication.shared.version }
        assertTrue { UIApplication.shared.buildNumber > 0 }
    }
}

#endif
