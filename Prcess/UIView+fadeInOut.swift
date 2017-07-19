//
//  UIView + fadeOut.swift
//  Gestalt
//
//  Created by Alexey Chekanov on 5/18/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit


extension UIView {
    func fadeIn(duration: TimeInterval) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration) { [unowned self] in
            self.alpha = 1
        }
    }
}

extension UIView {
    func fadeOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.alpha = 0
        }
        self.isHidden = true
    }
}


