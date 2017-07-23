//
//  Guides.TextStyles.Tools.swift
//  Prcess
//
//  Created by Alexey Chekanov on 7/21/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import Foundation
import UIKit


// MARK: - TextStyles struct

public struct TextStyle {
    
    var font: UIFont?
    var fontColor: UIColor?
    var fontBackgroundColor: UIColor?
    
    var baselineOffset: NSNumber?
    
    var strikethroughStyle: NSNumber?
    var strikethroughColorAttributeName: UIColor?
    
    var underlineStyle: NSNumber?
    var underlineColor: UIColor?
    
    var strokeWidth: NSNumber? // NSNumber. In the negative fills the text
    var strokeColor: UIColor?
    
    var textEffectAttributeName: String? // f.e.: NSTextEffectLetterpressStyle as NSString
    
    var ligature: NSNumber?
    var kern: NSNumber?
    
    // Paragraph
    var lineBreakMode: NSLineBreakMode?
    var allowsDefaultTighteningForTruncation: Bool?
    var hyphenationFactor: Float? // 0.0—1.0
    var alignment: NSTextAlignment?
    var lineHeightMultiple: CGFloat?
    
    // Shadow
    var shadowColor: UIColor?
    var shadowBlurRadius: CGFloat?
    var shadowOffset: CGSize?
}


// MARK: - Basic style

extension TextStyle {
    
    static let basic: TextStyle = TextStyle(
        font: nil,
        fontColor: nil,
        fontBackgroundColor: nil,
        
        baselineOffset: 0,
        
        strikethroughStyle: nil,
        strikethroughColorAttributeName: nil,
        
        underlineStyle: nil,
        underlineColor: nil,
        
        strokeWidth: nil,
        strokeColor: nil,
        
        textEffectAttributeName: nil,
        
        ligature: 1,
        kern: nil,
        
        lineBreakMode: NSLineBreakMode.byWordWrapping,
        allowsDefaultTighteningForTruncation: true,
        hyphenationFactor: 0.0,
        alignment: NSTextAlignment.natural,
        lineHeightMultiple: nil,
        
        shadowColor: nil,
        shadowBlurRadius: nil,
        shadowOffset: nil
    )
}


// MARK: - Empty template

extension TextStyle {
    static var empty: TextStyle {
        
        return TextStyle(
            font: nil,
            fontColor: nil,
            fontBackgroundColor: nil,
            
            baselineOffset: nil,
            
            strikethroughStyle: nil,
            strikethroughColorAttributeName: nil,
            
            underlineStyle: nil,
            underlineColor: nil,
            
            strokeWidth: nil,
            strokeColor: nil,
            
            textEffectAttributeName: nil,
            
            ligature: nil,
            kern: nil,
            
            lineBreakMode: nil,
            allowsDefaultTighteningForTruncation: true,
            hyphenationFactor: nil,
            alignment: nil,
            lineHeightMultiple: nil,
            
            shadowColor: nil,
            shadowBlurRadius: nil,
            shadowOffset: nil
        )
    }
}


// MARK: - NSMutableAttributedString extension

extension NSMutableAttributedString {
    
    
    private struct AssociatedKey {
        static var style: TextStyle? = nil
    }
    
    var style: TextStyle {
        get {
            if let result: TextStyle = objc_getAssociatedObject(self, &AssociatedKey.style) as? TextStyle {
                return result
            } else {
                let result = self.style
                self.style = result
                return result
            }
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.style, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.applyAttributes(ofStyle: self.style)
        }
    }
    
    
    func applyAttributes(ofStyle style: TextStyle) {
        
        var attributes = [String:Any]()
        
        if style.font != nil { attributes [NSFontAttributeName] = style.font }
        if style.fontColor != nil { attributes [NSForegroundColorAttributeName] = style.fontColor }
        if style.fontBackgroundColor != nil { attributes [NSBackgroundColorAttributeName] = style.fontBackgroundColor }
        
        if style.baselineOffset != nil { attributes [NSBaselineOffsetAttributeName] = style.baselineOffset }
        
        if style.strikethroughStyle != nil { attributes [NSStrikethroughStyleAttributeName] = style.strikethroughStyle }
        if style.strikethroughColorAttributeName != nil { attributes [NSStrikethroughColorAttributeName] = style.strikethroughColorAttributeName }
        
        if style.underlineStyle != nil { attributes [NSUnderlineStyleAttributeName] = style.underlineStyle }
        if style.underlineColor != nil { attributes [NSUnderlineColorAttributeName] = style.underlineColor }
        
        if style.strokeWidth != nil { attributes [NSStrokeWidthAttributeName] = style.strokeWidth }
        if style.strokeColor != nil { attributes [NSStrokeColorAttributeName] = style.strokeColor }
        
        if style.textEffectAttributeName != nil { attributes [NSTextEffectAttributeName] = style.textEffectAttributeName }
        
        if style.ligature != nil { attributes [NSLigatureAttributeName] = style.ligature }
        if style.kern != nil { attributes [NSKernAttributeName] = style.kern }
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        if style.lineBreakMode != nil { paragraphStyle.lineBreakMode = style.lineBreakMode! }
        if style.allowsDefaultTighteningForTruncation != nil { paragraphStyle.allowsDefaultTighteningForTruncation = style.allowsDefaultTighteningForTruncation! }
        if style.hyphenationFactor != nil { paragraphStyle.hyphenationFactor = style.hyphenationFactor! }
        if style.alignment != nil { paragraphStyle.alignment = style.alignment! }
        if style.lineHeightMultiple != nil { paragraphStyle.lineHeightMultiple = style.lineHeightMultiple! }
        
        attributes [NSParagraphStyleAttributeName] = paragraphStyle
        
        
        let shadowStyle = NSShadow()
        if style.shadowColor != nil { shadowStyle.shadowColor = style.shadowColor }
        if style.shadowBlurRadius != nil { shadowStyle.shadowBlurRadius = style.shadowBlurRadius! }
        if style.shadowOffset != nil { shadowStyle.shadowOffset = style.shadowOffset!}
        
        attributes [NSShadowAttributeName] = shadowStyle
        
        
        self.addAttributes(attributes, range: NSMakeRange(0, self.length))
    }
}



