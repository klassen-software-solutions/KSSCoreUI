//
//  NSApplicationExtension.swift
//  WSTerminal
//
//  Created by Steven W. Klassen on 2020-02-25.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import Cocoa
import KSSFoundation


public extension NSApplication {

    /**
     Return the name of the application as read from the bundle. Note that as the name is a required
     key in the bundle, if it does not exist this will cause a fatal error.
     */
    var name: String { Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String }

    /**
     Return the version of the application as read from the bundle. Note that as the verion is an optional
     key in the bundle, this may return nil.
     */
    var version: String? { Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String }

    /**
     Return the build number of the application as read from the bundle. Note that as the build number is a required
     key in the bundle, if it does not exist, or if it cannot be converted to an integer, this will cause a fatal error.

     - warning: If the bundle version includes a decimal point (which may be true during library unit testing) it will
        be rounded down to the nearest integer.
     */
    var buildNumber: Int { Int(Double(Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String)!) }


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
        let applicationDirectoryURL = commonURL.appendingPathComponent(self.name)

        // Find or create it.
        try fileManager.findOrCreateDirectory(at: applicationDirectoryURL,
                                              withIntermediateDirectories: true)
        return applicationDirectoryURL
    }

    /**
     Returns true if the current appearance is a dark mode appearance.
     */
    var isDarkMode: Bool {
        if #available(OSX 10.15, *) {
            let appearanceDescription = effectiveAppearance.debugDescription.lowercased()
            return appearanceDescription.contains("dark")
        } else {
            if let appleInterfaceStyle = UserDefaults.standard.object(forKey: "AppleInterfaceStyle") as? String {
                return appleInterfaceStyle.lowercased().contains("dark")
            }
            return false
        }
    }
}
#endif
