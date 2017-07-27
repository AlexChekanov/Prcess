//
//  UIView+shake.swift
//  Gestalt
//
//  Created by Alexey Chekanov on 6/27/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit

extension UIView {
    
    func shakeOff() {
        self.layer.removeAllAnimations()
    }
    
    func shakeOn(){
        
        self.layer.removeAllAnimations()
        
        let wiggleBounceY = 1.0
        let wiggleBounceDuration = 0.12
        let wiggleBounceDurationVariance = 0.024
        
        let wiggleRotateAngle = 0.02
        let wiggleRotateDuration = 0.10
        let wiggleRotateDurationVariance = 0.024
        
        func randomize(interval: TimeInterval, withVariance variance: Double) -> Double{
            let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
            return interval + variance * random
        }
        //Create rotation animation
        let rotationAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnim.values = [-wiggleRotateAngle, wiggleRotateAngle]
        rotationAnim.autoreverses = true
        rotationAnim.duration = randomize(interval: wiggleRotateDuration, withVariance: wiggleRotateDurationVariance)
        rotationAnim.repeatCount = HUGE
        
        //Create bounce animation
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounceAnimation.values = [wiggleBounceY, 0]
        bounceAnimation.autoreverses = true
        bounceAnimation.duration = randomize(interval: wiggleBounceDuration, withVariance: wiggleBounceDurationVariance)
        bounceAnimation.repeatCount = HUGE
        
        //Apply animations to view
        UIView.animate(withDuration: 0) {
            self.layer.add(rotationAnim, forKey: "rotation")
            self.layer.add(bounceAnimation, forKey: "bounce")
            self.transform = .identity
        }
    }
}
//
//func shakeOn() {
//
//    self.layer.removeAllAnimations()
//
//    let animationRotateDegres: CGFloat = 0.5
//    let animationTranslateX: CGFloat = 1.0
//    let animationTranslateY: CGFloat = 1.0
//    let count: Int = 1
//
//    let leftOrRight: CGFloat = (count % 2 == 0 ? 1 : -1)
//    let rightOrLeft: CGFloat = (count % 2 == 0 ? -1 : 1)
//    let leftWobble: CGAffineTransform = CGAffineTransform(rotationAngle: (animationRotateDegres.radians * leftOrRight))
//    let rightWobble: CGAffineTransform = CGAffineTransform(rotationAngle: (animationRotateDegres.radians * rightOrLeft))
//    let moveTransform: CGAffineTransform = leftWobble.translatedBy(x: -animationTranslateX, y: -animationTranslateY)
//    let conCatTransform: CGAffineTransform = leftWobble.concatenating(moveTransform)
//
//    transform = rightWobble // starting point
//
//    UIView.animate(withDuration: 0.1, delay: 0.08, options: [.allowUserInteraction, .repeat, .autoreverse], animations: { () -> Void in
//        self.transform = conCatTransform
//    }, completion: {
//
//        finished in
//        self.transform = CGAffineTransform.identity
//    })
//}
//
//func shakeOff() {
//    self.layer.removeAllAnimations()
//}


