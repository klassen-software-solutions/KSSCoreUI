//
//  NSViewControllerExtension.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-12.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import Foundation
import Cocoa
import KSSFoundation


public extension NSViewController {

    /**
     Search for and create if necessary a common directory for the containing application.

     - parameters:
        - directory: The directory we are searching for.
        - domain: The search domain.

     - throws:
     Any error that FileManager.findOrCreateDirectory may throw.

     - returns:
     The URL of the found directory.
     */
    func findOrCreateApplicationDirectory(for directory: FileManager.SearchPathDirectory,
                                          in domain: FileManager.SearchPathDomainMask) throws -> URL
    {
        // Determine the required directory path.
        let fileManager = FileManager.default
        let commonURL = try fileManager.url(for: directory,
                                            in: domain,
                                            appropriateFor: nil,
                                            create: true)
        let applicationName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let applicationDirectoryURL = commonURL.appendingPathComponent(applicationName)

        // Find or create it.
        try fileManager.findOrCreateDirectory(at: applicationDirectoryURL,
                                              withIntermediateDirectories: true)
        return applicationDirectoryURL
    }
}

#endif
