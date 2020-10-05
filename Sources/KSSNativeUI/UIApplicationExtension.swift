//
//  UIApplicationExtension.swift
//  
//
//  Created by Steven W. Klassen on 2020-10-05.
//

#if canImport(UIKit)

import UIKit

public extension UIApplication {

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
}

#endif
