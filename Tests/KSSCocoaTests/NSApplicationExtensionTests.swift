#if canImport(Cocoa)

import XCTest
import KSSCocoa
import KSSTest

class NSApplicationExtensionTests: XCTestCase {
    func testMetadata() {
        assertEqual(to: "xctest") { NSApplication.shared.name }
        assertNil { NSApplication.shared.version }
        assertTrue { NSApplication.shared.buildNumber > 0 }
    }

    func testIsDarkMode() {
        // There is no way for us to test this since we don't know what the developers
        // settings will be. So the only test is that it doesn't crash or anything.
        _ = NSApplication.shared.isDarkMode
    }
}

#endif
