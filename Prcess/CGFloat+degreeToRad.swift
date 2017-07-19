//
//  CGFloat+degreeToRad.swift
//  Gestalt
//
//  Created by Alexey Chekanov on 6/27/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit


extension CGFloat {
    
    var radians: CGFloat {
        return self/180.0*CGFloat(Double.pi)
    }
}

