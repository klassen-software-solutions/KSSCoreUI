#if canImport(Cocoa)

import XCTest
import KSSCocoa
import KSSTest

class NSImageExtensionTests: XCTestCase {
    func testInitFromInputStream() {
        var image = NSImage(fromInputStream: streamFromEncodedString(plusSymbolEncodedString))
        assertNotNil { image }
        assertEqual(to: 56) { image?.size.width }
        assertEqual(to: 56) { image?.size.height }

        image = NSImage(fromInputStream: streamFromEncodedString(notAnImageEncodedString))
        assertNil { image }
    }

    @available(OSX 10.14, *)
    func testInverted() {
        let inputImage = NSImage(fromInputStream: streamFromEncodedString(plusSymbolEncodedString))!
        let outputImage = inputImage.inverted()
        assertEqual(to: inputImage.size.width) { outputImage.size.width }
        assertEqual(to: inputImage.size.height) { outputImage.size.height }
        assertNotEqual(to: inputImage) { outputImage }
    }

    func testResized() {
        let image = NSImage(fromInputStream: streamFromEncodedString(plusSymbolEncodedString))?
            .resized(to: NSSize(width: 16, height: 18))
        assertNotNil { image }
        assertEqual(to: 16) { image?.size.width }
        assertEqual(to: 18) { image?.size.height }
    }
}

fileprivate let plusSymbolEncodedString = """
iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAMAAACfWMssAAAAYFBMVEUAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAD////68c6fAAAAHnRSTlMAAQgPERYXGSIkJSYnKDg7PJWWmJ+goaLa29zd/P0v
2OJcAAAAAWJLR0QfBQ0QvQAAAHhJREFUSMft1skKgCAQgGG1xTbb93Te/zHToxQYU6eY/zj4HQTBYYz6
edUyFRjHD4CNI2AKtgQBpYOSIEGCNhF7KQeVPxN3rtcQTHdX18Kjmu8gG0yYmeHuklHmVbuTtT+L6MkR
JPgGor9yvgOsmOWBlfOY09L2904sZSVqkhks3wAAAABJRU5ErkJggg==
"""

fileprivate let notAnImageEncodedString = "dGhpcyBzaG91bGQgbm90IGJlIGFuIGltYWdlCg=="

fileprivate func streamFromEncodedString(_ encodedString: String) -> InputStream {
    let decodedData = Data(base64Encoded: encodedString, options: .ignoreUnknownCharacters)!
    return InputStream(data: decodedData)
}

#endif
