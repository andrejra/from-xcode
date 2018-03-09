//
//  StringUtils.swift
//  lg1
//
//  Created by Andrej on 3/5/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation

class StringUtils {
    
    /**
     Populate an UITextView with text and add links to it.
     
     - Parameter    textView:   Desired UITextView to add links into.
     - Parameter    text:   A whole text. Contains strings which will be represented as links.
     - Parameter    linksWithUrls: Dictionary in which keys represent link text that occur somewhere in the entire text, and values represent the URLs.
     - Parameter    textColor: Non-link text color. Set this parameter to nil for default black color.
     */
//    static func textViewLink(textView: UITextView, text: String, linksWithUrls: [String : String], textColor: UIColor?, fontSize: Int, aligment: NSTextAlignment) {
//        let wholeText = NSMutableAttributedString(string: text)
//        let wholeRange = wholeText.mutableString.range(of: text)
//
//        for pair in linksWithUrls {
//            let linkRange = wholeText.mutableString.range(of: pair.key)
//            wholeText.addAttribute(NSLinkAttributeName, value: pair.value, range: linkRange)
//        }
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = center
//
//        wholeText.addAttribute(NSFontAttributeName, value: UIFont(name: "Calibre-Regular", size: CGFloat(fontSize))!, range: wholeRange)
//        wholeText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: wholeRange)
//
//        if textColor != nil {
//            wholeText.addAttribute(NSForegroundColorAttributeName, value: textColor!, range: wholeRange)
//        }
//        let fr8hubBlue = UIColor(red: 15.0/255.0, green: 33.0/255.0, blue: 86.0/255.0, alpha: 1.0)
//        let linkAttribute = [NSForegroundColorAttributeName: UIColor(red: 15.0/255.0, green: 33.0/255.0, blue: 86.0/255.0, alpha: 1.0), NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
//
//        textView.attributedText = wholeText
//        textView.linkTextAttributes = linkAttribute
//    }

}
