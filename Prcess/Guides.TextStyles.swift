//
//  Guides.TextStyles.swift
//  Prcess
//
//  Created by Alexey Chekanov on 7/21/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import Foundation
import UIKit


// MARK: - TextStyles


let basicDeselectedColor = UIColor.lightGray
let basicSelectedColor = UIColor.white
let basicFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)

extension TextStyle {
    
    // MARK: - Task Headline
    enum taskHeadline {
        
        //Planned
        enum planned {
            case selected, deselected
            
            var style: TextStyle {
                
                switch self {
                case .selected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicSelectedColor
                    
                    return δStyle
                    }()
                    
                case.deselected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicDeselectedColor
                    
                    return δStyle
                    }()
                }
            }
        }
        
        //Running
        enum running {
            case selected, deselected
            
            var style: TextStyle {
                
                switch self {
                case .selected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicSelectedColor
                    
                    return δStyle
                    }()
                    
                case.deselected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicDeselectedColor
                    
                    return δStyle
                    }()
                }
            }
        }
        
        //Suspended
        enum suspended {
            case selected, deselected
            
            var style: TextStyle {
                
                switch self {
                case .selected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicSelectedColor
                    
                    return δStyle
                    }()
                    
                case.deselected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicDeselectedColor
                    
                    return δStyle
                    }()
                }
            }
        }
        
        //Completed
        enum completed {
            case selected, deselected
            
            var style: TextStyle {
                
                switch self {
                case .selected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicSelectedColor
                    δStyle.strikethroughStyle = 2
                    δStyle.strikethroughColorAttributeName = basicSelectedColor
                    
                    return δStyle
                    }()
                    
                case.deselected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicDeselectedColor
                    δStyle.strikethroughStyle = 2
                    δStyle.strikethroughColorAttributeName = basicDeselectedColor
                    
                    
                    return δStyle
                    }()
                }
            }
        }
        
        //Canceled
        enum canceled {
            case selected, deselected
            
            var style: TextStyle {
                
                switch self {
                case .selected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicSelectedColor
                    
                    return δStyle
                    }()
                    
                case.deselected: return {
                    
                    var δStyle = TextStyle.basic
                    δStyle.font = basicFont
                    δStyle.fontColor = basicDeselectedColor
                    
                    return δStyle
                    }()
                }
            }
        }
    }
}


