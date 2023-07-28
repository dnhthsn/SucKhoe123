//
//  WebView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 04/07/2023.
//

import SwiftUI
import WebKit
import SafariServices
import MessageUI

public enum FontType {
    case system
    case monospaced
    case italic
    case custom(UIFont)
    case customName(String)

    @available(*, deprecated, renamed: "system")
    case `default`
    
    var name: String {
        switch self {
        case .monospaced:
            return UIFont.monospacedSystemFont(ofSize: 17, weight: .regular).fontName
        case .italic:
            return UIFont.italicSystemFont(ofSize: 17).fontName
        case .custom(let font):
            return font.fontName
        case .customName(let name):
            return name
        default:
            return "-apple-system"
        }
    }
}

public enum LinkOpenType {
    case SFSafariView(configuration: SFSafariViewController.Configuration = .init(), isReaderActivated: Bool? = nil, isAnimated: Bool = true)
    case Safari
    case none
}

public enum ColorPreference {
    case all
    case onlyLinks
    case none
}

public enum ColorScheme {
    case light
    case dark
    case auto
}

public struct WebHTMLText: View {
    @State private var dynamicHeight: CGFloat = .zero
    
    var height: CGFloat
    let html: String
    let checkCustom: Bool
    var configuration: ConfigurationHTML
    var placeholder: AnyView?
    
    public init(height: CGFloat, html: String, checkCustom: Bool, configuration: ConfigurationHTML = .init(), placeholder: AnyView? = nil) {
        self.html = html
        self.height = height
        self.checkCustom = checkCustom
        self.configuration = configuration
        self.placeholder = placeholder
    }

    public var body: some View {
        ZStack(alignment: .top) {
            WebView(dynamicHeight: $dynamicHeight, html: html, configuration: configuration)
                .frame(height: checkCustom ? height : dynamicHeight)

            if self.dynamicHeight == 0 {
                placeholder
            }
        }
    }
}

public struct ColorSet {
    private let light: String
    private let dark: String
    public var isImportant: Bool

    public init(light: String, dark: String, isImportant: Bool = false) {
        self.light = light
        self.dark = dark
        self.isImportant = isImportant
    }
    
    public init(light: UIColor, dark: UIColor, isImportant: Bool = false) {
        self.light = light.hex ?? "000000"
        self.dark = dark.hex ?? "F2F2F2"
        self.isImportant = isImportant
    }
    
    func value(_ isLight: Bool) -> String {
        "#\(isLight ? light : dark)\(isImportant ? " !important" : "")"
    }
}


public struct ConfigurationHTML {
    
    public var customCSS: String
    
    public var fontType: FontType
    public var fontColor: ColorSet
    public var lineHeight: CGFloat
    
    public var colorScheme: ColorScheme
    
    public var imageRadius: CGFloat
    
    public var linkOpenType: LinkOpenType
    public var linkColor: ColorSet
    
    public var isColorsImportant: ColorPreference
    
    public var transition: Animation?
    
    public init(
        customCSS: String = "",
        fontType: FontType = .system,
        fontColor: ColorSet = .init(light: "000000", dark: "F2F2F2"),
        lineHeight: CGFloat = 170,
        colorScheme: ColorScheme = .auto,
        imageRadius: CGFloat = 0,
        linkOpenType: LinkOpenType = .SFSafariView(),
        linkColor: ColorSet = .init(light: "007AFF", dark: "0A84FF", isImportant: true),
        isColorsImportant: ColorPreference = .onlyLinks,
        transition: Animation? = .none
    ) {
        self.customCSS = customCSS
        self.fontType = fontType
        self.fontColor = fontColor
        self.lineHeight = lineHeight
        self.colorScheme = colorScheme
        self.imageRadius = imageRadius
        self.linkOpenType = linkOpenType
        self.linkColor = linkColor
        self.isColorsImportant = isColorsImportant
        self.transition = transition
    }
    
    func css(isLight: Bool, alignment: TextAlignment) -> String {
        """
        img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
        h1, h2, h3, h4, h5, h6, p, div, dl, ol, ul, pre, blockquote {text-align:\(alignment.htmlDescription); line-height: \(lineHeight)%; font-family: '\(fontType.name)' !important; color: \(fontColor.value(isLight)); }
        iframe{width:100%; height:250px;}
        a:link {color: \(linkColor.value(isLight));}
        A {text-decoration: none;}
        """
    }
}


struct WebView: UIViewRepresentable {
    @Environment(\.multilineTextAlignment) var alignment
    @Binding var dynamicHeight: CGFloat

    let html: String
    let conf: ConfigurationHTML

    init(dynamicHeight: Binding<CGFloat>, html: String, configuration: ConfigurationHTML) {
        self._dynamicHeight = dynamicHeight

        self.html = html
        self.conf = configuration
    }

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        webview.scrollView.isScrollEnabled = false
        
        DispatchQueue.main.async {
            let bundleURL = Bundle.main.bundleURL
            webview.loadHTMLString(generateHTML(), baseURL: bundleURL)
        }
        
        webview.isOpaque = false
        webview.backgroundColor = UIColor.clear
        webview.scrollView.backgroundColor = UIColor.clear
        
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            let bundleURL = Bundle.main.bundleURL
            uiView.loadHTMLString(generateHTML(), baseURL: bundleURL)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.getElementById(\"NuPlay_RichText\").offsetHeight", completionHandler: { (height, _) in
                DispatchQueue.main.async {
                    if let height = height as? CGFloat {
                        withAnimation(self.parent.conf.transition) {
                            self.parent.dynamicHeight = height
                        }
                    } else {
                        self.parent.dynamicHeight = 0
                    }
                }
            })
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard navigationAction.navigationType == WKNavigationType.linkActivated,
                  var url = navigationAction.request.url else {
                decisionHandler(WKNavigationActionPolicy.allow)
                return
            }
            
            if url.scheme == nil {
                guard let httpsURL = URL(string: "https://\(url.absoluteString)") else { return }
                url = httpsURL
            }
            
            switch url.scheme {
            case "mailto", "tel":
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case "http", "https":
                switch self.parent.conf.linkOpenType {
                case .SFSafariView(let conf, let isReaderActivated, let isAnimated):
                    if let reader = isReaderActivated {
                        conf.entersReaderIfAvailable = reader
                    }
                    let root = UIApplication.shared.windows.first?.rootViewController
                    root?.present(SFSafariViewController(url: url, configuration: conf), animated: isAnimated, completion: nil)
                case .Safari:
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                case .none:
                    break
                }
            default:
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
    }
}

extension WebView {
    func generateHTML() -> String {
        return """
            <HTML>
            <head>
                <meta name='viewport' content='width=device-width, shrink-to-fit=YES, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
            </head>
            \(generateCSS())
            <div id="NuPlay_RichText">\(html)</div>
            </BODY>
            </HTML>
            """
    }
    
    func generateCSS() -> String {
        switch conf.colorScheme {
        case .light:
            return """
            <style type='text/css'>
                \(conf.css(isLight: true, alignment: alignment))
                \(conf.customCSS)
                body {
                    margin: 0;
                    padding: 0;
                }
            </style>
            <BODY>
            """
        case .dark:
            return """
            <style type='text/css'>
                \(conf.css(isLight: false, alignment: alignment))
                \(conf.customCSS)
                body {
                    margin: 0;
                    padding: 0;
                }
            </style>
            <BODY>
            """
        case .auto:
            return """
            <style type='text/css'>
            @media (prefers-color-scheme: light) {
                \(conf.css(isLight: true, alignment: alignment))
            }
            @media (prefers-color-scheme: dark) {
                \(conf.css(isLight: false, alignment: alignment))
            }
            \(conf.customCSS)
            body {
                margin: 0;
                padding: 0;
            }
            </style>
            <BODY>
            """
        }
    }
}

extension UIColor {
    var hex: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

public extension TextAlignment {
    var htmlDescription: String {
        switch self {
        case .center:
            return "center"
        case .leading:
            return "left"
        case .trailing:
            return "right"
        }
    }
}

extension WebHTMLText {
    public func customCSS(_ customCSS: String) -> WebHTMLText {
        var result = self
        result.configuration.customCSS += customCSS
        return result
    }
    
    public func lineHeight(_ lineHeight: CGFloat) -> WebHTMLText {
        var result = self
        result.configuration.lineHeight = lineHeight
        return result
    }
    
    public func colorScheme(_ colorScheme: ColorScheme) -> WebHTMLText {
        var result = self
        result.configuration.colorScheme = colorScheme
        return result
    }

    public func imageRadius(_ imageRadius: CGFloat) -> WebHTMLText {
        var result = self
        result.configuration.imageRadius = imageRadius
        return result
    }

    public func fontType(_ fontType: FontType) -> WebHTMLText {
        var result = self
        result.configuration.fontType = fontType
        return result
    }
    
    @available(iOS 14.0, *)
    public func foregroundColor(light: Color, dark: Color) -> WebHTMLText {
        var result = self
        result.configuration.fontColor = .init(light: UIColor(light), dark: UIColor(dark))
        return result
    }
    
    public func foregroundColor(light: UIColor, dark: UIColor) -> WebHTMLText {
        var result = self
        result.configuration.fontColor = .init(light: light, dark: dark)
        return result
    }
    
    @available(iOS 14.0, *)
    public func linkColor(light: Color, dark: Color) -> WebHTMLText {
        var result = self
        result.configuration.linkColor = .init(light: UIColor(light), dark: UIColor(dark))
        return result
    }
    
    public func linkColor(light: UIColor, dark: UIColor) -> WebHTMLText {
        var result = self
        result.configuration.linkColor = .init(light: light, dark: dark)
        return result
    }

    public func linkOpenType(_ linkOpenType: LinkOpenType) -> WebHTMLText {
        var result = self
        result.configuration.linkOpenType = linkOpenType
        return result
    }
    
    public func colorPreference(forceColor: ColorPreference) -> WebHTMLText {
        var result = self
        result.configuration.isColorsImportant = forceColor
        
        switch forceColor {
        case .all:
            result.configuration.linkColor.isImportant = true
            result.configuration.fontColor.isImportant = true
        case .onlyLinks:
            result.configuration.linkColor.isImportant = true
            result.configuration.fontColor.isImportant = false
        case .none:
            result.configuration.linkColor.isImportant = false
            result.configuration.fontColor.isImportant = false
        }
        
        return result
    }
    
    public func placeholder<T>(@ViewBuilder content: () -> T) -> WebHTMLText where T: View {
        var result = self
        result.placeholder = AnyView(content())
        return result
    }
    
    public func transition(_ transition: Animation?) -> WebHTMLText {
        var result = self
        result.configuration.transition = transition
        return result
    }
}

// MARK: - Deprected Functions
/*
public extension RichText {
    @available(*, deprecated, renamed: "colorScheme(_:)")
    func colorScheme(_ colorScheme: colorScheme) -> RichText {
        var result = self
        
        switch colorScheme {
        case .light:
            result.configuration.colorScheme = .light
        case .dark:
            result.configuration.colorScheme = .dark
        case .automatic:
            result.configuration.colorScheme = .auto
        }
        
        return result
    }
    
    @available(*, deprecated, renamed: "colorPreference(_:)")
    func colorImportant(_ colorImportant: Bool) -> RichText {
        var result = self
        result.configuration.isColorsImportant = colorImportant ? .all : .none
        return result
    }
    
    @available(*, deprecated, renamed: "fontType(_:)")
    func fontType(_ fontType: fontType) -> RichText {
        var result = self
        
        switch fontType {
        case .system:
            result.configuration.fontType = .system
        case .monospaced:
            result.configuration.fontType = .monospaced
        case .italic:
            result.configuration.fontType = .italic
        case .default:
            result.configuration.fontType = .system
        }
        
        return result
    }
    
    @available(*, deprecated, renamed: "linkOpenType(_:)")
    func linkOpenType(_ linkOpenType: linkOpenType) -> RichText {
        var result = self
        
        switch linkOpenType {
        case .SFSafariView:
            result.configuration.linkOpenType = .SFSafariView()
        case .SFSafariViewWithReader:
            result.configuration.linkOpenType = .SFSafariView(isReaderActivated: true)
        case .Safari:
            result.configuration.linkOpenType = .Safari
        case .none:
            result.configuration.linkOpenType = .none
        }
        
        return result
    }
}
*/
