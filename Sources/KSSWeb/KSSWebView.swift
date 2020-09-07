//
//  KSSWebView.swift
//
//  Created by Steven W. Klassen on 2020-02-20.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

#if canImport(Cocoa)

import Cocoa
import SwiftUI
import WebKit
import os

/**
 SwiftUI view for displaying HTML. This is essentially a SwiftUI wrapper around a WKWebView.
 */
@available(OSX 10.15, *)
@available(iOS, unavailable)
public struct KSSWebView: NSViewRepresentable {
    /**
     A binding to the URL whose content is to be displayed.
     */
    @Binding public var url: URL

    /**
     Construct a web view bound to the given url.
     */
    public init(url: Binding<URL>) {
        self._url = url
    }

    /// :nodoc:
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// :nodoc:
    public func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if url.scheme == "http" || url.scheme == "https" {
            let request = URLRequest(url: url)
            webView.load(request)
        } else if url.scheme == "file" {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            os_log("Not sure how to handle url: %s", url.absoluteString)
        }
        webView.navigationDelegate = context.coordinator
        return webView
    }

    /// :nodoc:
    public func updateNSView(_ nsView: WKWebView, context: Context) {
        // Intentionally empty
    }
}

/// :nodoc:
@available(OSX 10.15, *)
extension KSSWebView {
    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: KSSWebView

        init(_ parent: KSSWebView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                if url.scheme == "file" {
                    decisionHandler(.allow)
                    return
                } else if url.scheme == "http" || url.scheme == "https" || url.scheme == "mailto" {
                    decisionHandler(.cancel)
                    NSWorkspace.shared.open(url)
                    return
                }
            }
            os_log("Unsupported request: %s", navigationAction.request.url?.absoluteString ?? "No URL")
            decisionHandler(.cancel)
        }
    }
}

#else

// Force the compiler to give us a more descriptive message.
@available(iOS, unavailable)
public struct KSSWebView {}

#endif
