//
//  UILabel+flexibleWidth.swift
//  Gestalt
//
//  Created by Alexey Chekanov on 5/18/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(
        text: String?,
        font: UIFont?,
        
        maximumNumberOfLines: Int?,
        
        lineBreakMode: NSLineBreakMode?,
        
        constantElementsWidth: CGFloat,
        acceptableWidthForTextOfOneLine: CGFloat, //When we don't want the text to be shrinked
        
        
        textColor:UIColor?,
        backgroundColor:UIColor?,
        textAlignment:NSTextAlignment?,
        userInteractionEnabled:Bool?
        )
    {
        
        let theFont: UIFont = font ?? UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        let lineSpacingCoefficient: CGFloat = 1.1
        
        let targetHeight = CGFloat(maximumNumberOfLines ?? 1)*(theFont.lineHeight)*lineSpacingCoefficient
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode ?? .byWordWrapping
        paragraphStyle.allowsDefaultTighteningForTruncation = true
        paragraphStyle.hyphenationFactor = 0
        
        
        let attributes: [String:Any] = [
            NSFontAttributeName: theFont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSBaselineOffsetAttributeName: 0
        ]
        
        let attributedString = NSAttributedString(string: (text ?? ""), attributes: attributes)
        
        
        let boundingSize = attributedString.boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: theFont.lineHeight),
            options: [NSStringDrawingOptions.usesLineFragmentOrigin],
            context: nil).size
        
        let maximalLabelWidth = boundingSize.width
        let minimalHeight = boundingSize.height
        
        let frame_:CGRect = {
            
            var frameToReturn: CGRect = CGRect.zero
            
            if !text.isNilOrEmpty {
                
                if  (maximalLabelWidth < acceptableWidthForTextOfOneLine) || (text!.wordList.count == 1) {
                    
                    frameToReturn = CGRect(origin: CGPoint.zero, size: CGSize(width: maximalLabelWidth+constantElementsWidth, height: minimalHeight))
                } else {
                    
                    // Minimal width, calculated based on the longest word
                    
                    let maxWordsCharacterCount = text!.longestWord.characters.count
                    let allLongWords: [String] = text!.wordList.filter {$0.characters.count == maxWordsCharacterCount}
                    var sizes: [CGFloat] = []
                    allLongWords.forEach {sizes.append($0.size(attributes: attributes).width)}
                    let minimalWidth = sizes.max()!
                    
                    
                    // Height calculation
                    var flexibleWidth = maximalLabelWidth
                    var flexibleHeight = CGFloat()
                    
                    var optimalWidth = CGFloat()
                    var optimalHeight = CGFloat()
                    
                    var widthJumps = [CGFloat]()
                    
                    // Accelerator
                    var testWidth = flexibleWidth
                    var testHeight: CGFloat = 0.0
                    var startWidth: CGFloat = 0.0
                    var testWidthShouldBeMultipliedOnNextIteration = false
                    
                    for _ in 1...6 {
                        
                        testWidth /= 2
                        testWidthShouldBeMultipliedOnNextIteration ? (
                            testWidth *= 3) : ()
                        testHeight = attributedString.boundingRect(
                            with: CGSize(width: testWidth, height: CGFloat.greatestFiniteMagnitude),
                            options: [NSStringDrawingOptions.usesLineFragmentOrigin],
                            context: nil).size.height
                        if testHeight > targetHeight {
                            testWidthShouldBeMultipliedOnNextIteration = true
                        }  else {
                            startWidth = testWidth
                            testWidthShouldBeMultipliedOnNextIteration = false
                        }
                    }
                    print(startWidth)
                    
                    if (startWidth > 0.0 && startWidth >= minimalWidth) {flexibleWidth = startWidth}
                    
                    
                    
                    // Main method
                    while (flexibleHeight <= targetHeight && flexibleWidth >= minimalWidth) {
                        
                        if optimalHeight != flexibleHeight {
                            
                            widthJumps.append(flexibleWidth+1) //fixing line jumps caused previous incremention
                            optimalHeight = flexibleHeight
                        }
                        
                        optimalWidth = flexibleWidth
                        
                        flexibleWidth -= 1
                        
                        flexibleHeight = attributedString.boundingRect(
                            with: CGSize(width: flexibleWidth, height: CGFloat.greatestFiniteMagnitude),
                            options: [NSStringDrawingOptions.usesLineFragmentOrigin],
                            context: nil).size.height
                        
                        print("Width: \(flexibleWidth)")
                        print("Height: \(flexibleHeight)")
                        print("_______________________")
                    }
                    
                    print("Final Width: \(optimalWidth)")
                    print("Final Height: \(optimalHeight)")
                    
                    if (widthJumps.count > 1) && (optimalWidth/widthJumps.last! >= 0.72) {optimalWidth = widthJumps.last!}
                    
                    
                    frameToReturn = CGRect(origin: CGPoint.zero, size: CGSize(width: optimalWidth+constantElementsWidth, height: optimalHeight))
                    
                }
            }
            return frameToReturn
        }()
        
        self.init(frame: frame_)
        if !text.isNilOrEmpty{
            self.attributedText = NSAttributedString(string: text!, attributes: attributes)
        }
        if (textColor != nil){
            self.textColor=textColor
        }
        self.backgroundColor = backgroundColor ?? UIColor.clear
        self.adjustsFontSizeToFitWidth = false
        self.numberOfLines = maximumNumberOfLines ?? 1
        self.lineBreakMode = lineBreakMode ?? .byWordWrapping
        self.textAlignment = textAlignment ?? .natural
        self.isUserInteractionEnabled = userInteractionEnabled ?? false
    }
}
