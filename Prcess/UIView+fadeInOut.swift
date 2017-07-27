//
//  UIView + fadeOut.swift
//  Gestalt
//
//  Created by Alexey Chekanov on 5/18/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit


extension UIView {
    
    func fadeInResized(duration: TimeInterval) {
        guard self.alpha < 1 else { return }
        
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }
    }
    
    func fadeOutResized(duration: TimeInterval) {
        guard self.alpha > 0 else { return }
        
        UIView.animate(withDuration: duration, animations: { [unowned self] () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0
            }, completion: nil)
    }
}


