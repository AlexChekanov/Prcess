//
//  Guides.swift
//  Guidelines
//
//  Created by Alexey Chekanov on 7/11/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import Foundation
import UIKit

struct Shadow {
    
    let shadowColor: UIColor
    let shadowOffset: CGSize
    let shadowRadius: CGFloat
    let shadowOpacity: Float
    let masksToBound: Bool?
    
    enum ShadowStyle {
        case soft
        case hard
        
        func value () -> Shadow {
            switch self {
            case .soft:
                return Shadow (shadowColor: #colorLiteral(red: 0.925490200519562, green: 0.235294118523598, blue: 0.10196078568697, alpha: 1.0), shadowOffset: CGSize(width: 4.0, height: 2.0), shadowRadius: 8, shadowOpacity: 0.8, masksToBound: false)
            case .hard:
                return Shadow (shadowColor: #colorLiteral(red: 0.925490200519562, green: 0.235294118523598, blue: 0.10196078568697, alpha: 1.0), shadowOffset: CGSize(width: 4.0, height: 2.0), shadowRadius: 8, shadowOpacity: 0.8, masksToBound: false)
            }
            
        }
    }
}

extension Shadow {
    static var none: Shadow {
        return Shadow(shadowColor: .clear, shadowOffset: CGSize.zero, shadowRadius: 0, shadowOpacity: 0, masksToBound: nil)
    }
    
    static var soft: Shadow {
        return Shadow(shadowColor: .black, shadowOffset: CGSize(width: 2.0, height: 6.0), shadowRadius: 8, shadowOpacity: 0.8, masksToBound: false)
    }

}


extension UIView {
    
    
    private struct AssociatedKey {
        static var shadowStyle: Shadow? = nil
    }
    
    var shadowStyle: Shadow {
        get {
            if let result: Shadow = objc_getAssociatedObject(self, &AssociatedKey.shadowStyle) as? Shadow {
                return result
            } else {
                let result = self.shadowStyle
                self.shadowStyle = result
                return result
            }
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.shadowStyle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.applyShadow(ofStyle: self.shadowStyle)
        }
    }
    
    
    func applyShadow(ofStyle style: Shadow) {
        self.layer.shadowColor = style.shadowColor.cgColor
        self.layer.shadowOffset = style.shadowOffset
        self.layer.shadowRadius = style.shadowRadius
        self.layer.shadowOpacity = style.shadowOpacity
        if style.masksToBound != nil {
            self.layer.masksToBounds = style.masksToBound!
        }
    }
}
