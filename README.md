# KSSCoreUI
Miscellaneous Swift UI utilities

## Description

This package is divided into a number of Swift Modules providing utility methods related to UI
classes. A key feature of this package is that it has no dependencies other than the KSSCore
libraries and a standard Apple development environment.

The modules provided by this package are the following:

* _KSSMap_ - items that depend on MapKit
* _KSSNativeUI_ - items that depend on either Cocoa (macOS) or UIKit (iOS)
* _KSSSwiftUI_ - items that depend on SwiftUI
* _KSSWeb_ - items that depend on WebKit

 [API Documentation](https://www.kss.cc/apis/KSSCoreUI/docs/index.html)
 
 ## What is New in Version 2
 
 There are no API changes in V2, however the minumum Mac OS is now 10.12 instead of 10.11
 and the minimum KSSCore is V5.
 
 ## Module Availability
 
 Note that not all modules are available on all architectures. In addition, within a module there will
 be things that are only available on some architectures. For example, anything that depends on
 Cocoa will be available on _macOS_ but not on _iOS_.
 
 Presently we support the following:
 
 * _macOS_ - All modules are available
 * _iOS_ - All modules are available, except for `KSSWeb`.
 
