//
//  Guides.Shadows.Tools.swift
//  Guidelines
//
//  Created by Alexey Chekanov on 7/11/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import Foundation
import UIKit


// MARK: Shadows struct

struct Shadow {
    
    let shadowColor: UIColor
    let shadowOffset: CGSize
    let shadowRadius: CGFloat
    let shadowOpacity: Float
    let masksToBound: Bool?
    
}


// MARK: UIView extension

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
