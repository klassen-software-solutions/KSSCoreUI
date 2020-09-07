//
//  NSImageExtension.swift
//
//  Created by Steven W. Klassen on 2020-03-04.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import os
import AppKit
import Cocoa
import Foundation

public extension NSImage {

    /**
     Reads an image from an input stream. Will be nil if there is an error reading the stream or if
     the stream does not contain a supported image type.
     */
    convenience init?(fromInputStream inStream: InputStream) {
        inStream.open()
        defer { inStream.close() }
        if let imageData = try? Data(fromInputStream: inStream) {
            self.init(data: imageData)
            return
        }
        return nil
    }

    /**
     Performs a color invert of the image and returns the new one. If an error occurs, a message is logged
     and the original image is returned.
     */
    @available(OSX 10.14, *)
    func inverted() -> NSImage {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            os_log(.error, "Could not create CGImage from NSImage")
            return self
        }

        let ciImage = CIImage(cgImage: cgImage)
        guard let filter = CIFilter(name: "CIColorInvert") else {
            os_log(.error, "Could not create CIColorInvert filter")
            return self
        }

        filter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else {
            os_log(.error, "Could not obtain output CIImage from filter")
            return self
        }

        guard let outputCgImage = outputImage.toCGImage() else {
            os_log(.error, "Could not create CGImage from CIImage")
            return self
        }

        return NSImage(cgImage: outputCgImage, size: self.size)
    }

    /**
     Resize an image to fit within the given size.
     - note: This is based on code found at https://stackoverflow.com/questions/11949250/how-to-resize-nsimage/42915296#42915296
     */
    func resized(to newSize: NSSize) -> NSImage? {
        if let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height),
                                            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                            colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0)
        {
            bitmapRep.size = newSize
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
            draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: .zero, operation: .copy, fraction: 1.0)
            NSGraphicsContext.restoreGraphicsState()

            let resizedImage = NSImage(size: newSize)
            resizedImage.addRepresentation(bitmapRep)
            return resizedImage
        }

        return nil
    }
}

fileprivate extension CIImage {
    func toCGImage() -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(self, from: self.extent) {
            return cgImage
        }
        return nil
    }
}

#endif
