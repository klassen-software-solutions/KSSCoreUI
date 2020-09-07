# Native UI Notes

The Native UI library contains items, primarily extensions, that are based on either
Cocoa (macOS) or UIKit (iOS). Often these are containing items that help create applications
in one or the other, but are not covered by SwiftUI. In other cases, `KSSSwiftUI` may have
different implementations of a class using either the Cocoa or UIKit versions of
something in `KSSNativeUI`.

In terms of availability, you should simply assume that anything that starts with `NS...`
is only available on Cocoa based systems and anything that starts with `UI...` is only
available on iOS based system.
