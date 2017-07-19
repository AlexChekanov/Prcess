//
//  UIView+shake.swift
//  Gestalt
//
//  Created by Alexey Chekanov on 6/27/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit

extension UIView {
    
    func shakeOn() {
        
        let animationRotateDegres: CGFloat = 0.5
        let animationTranslateX: CGFloat = 1.0
        let animationTranslateY: CGFloat = 1.0
        let count: Int = 1
        
        let leftOrRight: CGFloat = (count % 2 == 0 ? 1 : -1)
        let rightOrLeft: CGFloat = (count % 2 == 0 ? -1 : 1)
        let leftWobble: CGAffineTransform = CGAffineTransform(rotationAngle: (animationRotateDegres.radians * leftOrRight))
        let rightWobble: CGAffineTransform = CGAffineTransform(rotationAngle: (animationRotateDegres.radians * rightOrLeft))
        let moveTransform: CGAffineTransform = leftWobble.translatedBy(x: -animationTranslateX, y: -animationTranslateY)
        let conCatTransform: CGAffineTransform = leftWobble.concatenating(moveTransform)
        
        transform = rightWobble // starting point
        
        UIView.animate(withDuration: 0.1, delay: 0.08, options: [.allowUserInteraction, .curveEaseOut, .repeat, .autoreverse], animations: { () -> Void in
            self.transform = conCatTransform
        }, completion: {
        
            finished in
            self.transform = CGAffineTransform.identity
            })
    }
    
    func shakeOff() {
        
        self.layer.removeAllAnimations()
    }
}

