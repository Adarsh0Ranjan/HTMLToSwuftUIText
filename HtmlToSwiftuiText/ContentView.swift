//
//  ContentView.swift
//  HtmlToSwiftuiText
//
//  Created by Adarsh Ranjan on 16/09/24.
//

import SwiftUI

import SwiftUI


struct ContentView: View {
    var body: some View {
        ScrollView {
            // Block 1: Bold font, Red color
            AttributedText(.html(
                withBody: """
                <ul><li><strong>Lightweight and compact design for easy transportation and storage</strong></li><li><strong>Can bear up to 150kg, making it suitable for various outdoor activities</strong></li><li><strong>Can bear up to 150kg, making it suitable for various outdoor activities</strong></li></ul>
                """,
                customFont: UIFont.boldSystemFont(ofSize: 16),
                textColor: UIColor.red
            ))
            .padding()
            
            // Block 2: Italic font, Blue color
            AttributedText(.html(
                withBody: """
                <ul><li>Lightweight and compact design for easy transportation and storage</li><li>Can bear up to 150kg, making it suitable for various outdoor activities</li><li>Can bear up to 150kg, making it suitable for various outdoor activities</li></ul>
                """,
                customFont: UIFont.italicSystemFont(ofSize: 14),
                textColor: UIColor.blue
            ))
            .padding()
            
            // Block 3: Bold and Underlined, Green color
            AttributedText(.html(
                withBody: """
                <ul><li><strong><u>Lightweight and compact design for easy transportation and storage</u></strong></li><li><strong><u>Can bear up to 150kg, making it suitable for various outdoor activities</u></strong></li><li><strong><u>Can bear up to 150kg, making it suitable for various outdoor activities</u></strong></li></ul>
                """,
                customFont: UIFont.boldSystemFont(ofSize: 16),
                textColor: UIColor.green
            ))
            .padding()
            
            // Block 4: Underlined, Orange color
            AttributedText(.html(
                withBody: """
                <ul><li><u>Lightweight and compact design for easy transportation and storage</u></li><li><u>Can bear up to 150kg, making it suitable for various outdoor activities</u></li><li><u>Can bear up to 150kg, making it suitable for various outdoor activities</u></li></ul>
                """,
                customFont: UIFont.systemFont(ofSize: 14),
                textColor: UIColor.orange
            ))
            .padding()
            
            // Block 5: Bold & Underlined, Purple color
            AttributedText(.html(
                withBody: """
                <p><strong><u>Lightweight and compact design for easy transportation and storage</u></strong></p><p><strong><u>Can bear up to 150kg, making it suitable for various outdoor activities</u></strong></p><p><strong><u>Can bear up to 150kg, making it suitable for various outdoor activities</u></strong></p>
                """,
                customFont: UIFont.boldSystemFont(ofSize: 16),
                textColor: UIColor.purple
            ))
            .padding()
            
            // Block 6: Underlined, Cyan color
            AttributedText(.html(
                withBody: """
                <p><u>Lightweight and compact design for easy transportation and storage</u></p><p><u>Can bear up to 150kg, making it suitable for various outdoor activities</u></p><p><u>Can bear up to 150kg, making it suitable for various outdoor activities</u></p>
                """,
                customFont: UIFont.systemFont(ofSize: 14),
                textColor: UIColor.cyan
            ))
            .padding()
        }
        .navigationTitle("Custom HTML with Styles")
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct AttributedText: UIViewRepresentable {
    private let attributedString: NSAttributedString
    
    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
    
    func makeUIView(context: Context) -> UITextView {
        // Called the first time SwiftUI renders this "View".
        
        let uiTextView = UITextView()
        
        // Make it transparent so that background Views can shine through.
        uiTextView.backgroundColor = .clear
        
        // For text visualisation only, no editing.
        uiTextView.isEditable = false
        
        // Make UITextView flex to available width, but require height to fit its content.
        // Also disable scrolling so the UITextView will set its `intrinsicContentSize` to match its text content.
        uiTextView.isScrollEnabled = false
        uiTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiTextView.setContentCompressionResistancePriority(.required, for: .vertical)
        uiTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return uiTextView
    }
    
    func updateUIView(_ uiTextView: UITextView, context: Context) {
        // Called the first time SwiftUI renders this UIViewRepresentable,
        // and whenever SwiftUI is notified about changes to its state. E.g via a @State variable.
        uiTextView.attributedText = attributedString
    }
}

import UIKit

extension NSAttributedString {
    static func html(withBody body: String, customFont: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black) -> NSAttributedString {
        let bundle = Bundle.main
        let lang = bundle.preferredLocalizations.first ?? bundle.developmentLocalization ?? "en"
        
        let htmlData = """
        <!doctype html>
        <html lang="\(lang)">
        <head>
            <meta charset="utf-8">
            <style type="text/css">
                body {
                    font: -apple-system-body;
                    color: \(textColor.hex); /* This is for the initial rendering from HTML */
                }
                h1, h2, h3, h4, h5, h6 {
                    color: \(UIColor.label.hex);
                }
                a {
                    color: \(UIColor.systemGreen.hex);
                }
                li:last-child {
                    margin-bottom: 1em;
                }
            </style>
        </head>
        <body>
            \(body)
        </body>
        </html>
        """.data(using: .utf8)!
        
        // Parse HTML to an attributed string
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = (try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil)) ?? NSAttributedString(string: body)
        
        // Define the custom attributes for font and text color
        let attributes: [NSAttributedString.Key: Any] = [
            .font: customFont,
            .foregroundColor: textColor
        ]
        
        // Create a mutable copy to apply attributes
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        
        // Apply the custom attributes to the entire string
        mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttributedString.length))
        
        return mutableAttributedString
    }
}


// MARK: Converting UIColors into CSS friendly color hex string

private extension UIColor {
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(
            format: "#%02lX%02lX%02lX%02lX",
            lroundf(Float(red * 255)),
            lroundf(Float(green * 255)),
            lroundf(Float(blue * 255)),
            lroundf(Float(alpha * 255))
        )
    }
}
