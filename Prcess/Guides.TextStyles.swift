//
//  Guides.TextStyles.swift
//  Prcess
//
//  Created by Alexey Chekanov on 7/21/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import Foundation
import UIKit


// Mark: TextStyles


extension TextStyle {
    static var regularTaskHeadline: TextStyle {
        
        return TextStyle(
            font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
            fontColor: UIColor.lightGray,
            fontBackgroundColor: nil,
            
            baselineOffset: 0,
            
            strikethroughStyle: 0,
            strikethroughColorAttributeName: UIColor.clear,
            
            underlineStyle: 0,
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
}

extension TextStyle {
    static var loaded: TextStyle {
        
        return TextStyle(
            font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
            fontColor: UIColor.lightGray,
            fontBackgroundColor: UIColor.yellow,
            
            baselineOffset: 0,
            
            strikethroughStyle: 1,
            strikethroughColorAttributeName: UIColor.green,
            
            underlineStyle: 3,
            underlineColor: UIColor.blue,
            
            strokeWidth: -2,
            strokeColor: UIColor.cyan,
            
            textEffectAttributeName: NSTextEffectLetterpressStyle,
            
            ligature: 1,
            kern: 0,
            
            lineBreakMode: NSLineBreakMode.byWordWrapping,
            allowsDefaultTighteningForTruncation: true,
            hyphenationFactor: 0.0,
            alignment: NSTextAlignment.center,
            lineHeightMultiple: 0.4,
            
            shadowColor: .red,
            shadowBlurRadius: 8,
            shadowOffset: CGSize (width: 10, height: 10)
        )
    }
}

extension TextStyle {
    static var stamp: TextStyle {
        
        return TextStyle(
            font: UIFont.boldSystemFont(ofSize: 18),
            fontColor: .red,
            fontBackgroundColor: nil,
            
            baselineOffset: 0,
            
            strikethroughStyle: nil,
            strikethroughColorAttributeName: nil,
            
            underlineStyle: nil,
            underlineColor: nil,
            
            strokeWidth: nil,
            strokeColor: nil,
            
            textEffectAttributeName: NSTextEffectLetterpressStyle,
            
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

