//
//  StepCell.swift
//  Prcess
//
//  Created by Alexey Chekanov on 7/3/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit

class StepCell: UICollectionViewCell {
    
    //Mark: - @IBOutlets
    
    @IBOutlet private weak var theTitle: UILabel!
    @IBOutlet private weak var arrow: UILabel!
    @IBOutlet private weak var x: UIButton!
    @IBOutlet private weak var plus: UIButton!
    @IBOutlet weak var lock: UIButton!
    
    @IBOutlet private weak var main: UIView!
    @IBOutlet private weak var service: UIView!
    
    
    //Mark: - Variables
    
    let guides = Guides()
    let constantElementsWidth: CGFloat = 65
    
    
    //MARK: - Initialization
    
    func cleanUp(){
        
        self.main.shakeOff()
        title = nil
        isTheFirstCell = false
        canBeMoved = false
        canBeDeleted = false
    }

    
    //Mark: - Initial Calculations
    
    func doInitialCalculations() {
    }
    
    //MARK: - Inputs
    
    var object: Task? = nil {
        
        didSet {
            
            if object != nil {
                
                let attributeString =  NSAttributedString(string: (object?.title)!, attributes: guides.textAttributes)
                
                
//                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (object?.title)!)
//                
//                attributeString.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: NSMakeRange(0, attributeString.length))
//                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
//                attributeString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.lightGray.withAlphaComponent(0.8), range: NSMakeRange(0, attributeString.length))
                
                title = attributeString
                canBeMoved = (object?.canBeMoved)!
                canBeDeleted = (object?.canBeDeleted)!
            }
        }
    }
    
    var title: NSAttributedString? = nil {
        didSet {
            theTitle.attributedText = title
        }
    }
    let titleFont: UIFont = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBlack)
    
    var titleSelectedTextColor: UIColor = .white
    var titleDeselectedTextColor: UIColor = .lightGray
    var titleIsHidden: Bool = false {
        didSet {
            titleIsHidden ? theTitle.fadeOut(duration: 0.2) : theTitle.fadeIn(duration: 0.2)
        }
    }
    var titleIsSelected: Bool = false {
        didSet {
            titleIsSelected ? (theTitle.textColor = titleSelectedTextColor) : (theTitle.textColor = titleDeselectedTextColor)
        }
    }
    
    var arrowFont: UIFont = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
    var arrowTextColor: UIColor = .lightGray
    var arrowIsHidden: Bool = false {
        didSet {
            arrowIsHidden ? arrow.fadeOut(duration: 0.2) : arrow.fadeIn(duration: 0.2)
        }
    }
    
    
    var xShadowColor: UIColor = .black
    var xShadowOffset: CGSize = CGSize(width: 2.0, height: 6.0)
    var xShadowRadius: CGFloat = 8
    var xShadowOpacity: Float = 0.8
    var xIsHidden: Bool = false {
        didSet {
            xIsHidden ? x.fadeOut(duration: 0.2) : x.fadeIn(duration: 0.2)
        }
    }
    
    var lockShadowColor: UIColor = .black
    var lockShadowOffset: CGSize = CGSize(width: 2.0, height: 6.0)
    var lockShadowRadius: CGFloat = 8
    var lockShadowOpacity: Float = 0.8
    var lockIsHidden: Bool = false {
        didSet {
            lockIsHidden ? lock.fadeOut(duration: 0.2) : lock.fadeIn(duration: 0.2)
        }
    }
    
    var plusTintColor: UIColor = .lightGray
    var plusIsHidden: Bool = false {
        didSet {
            plusIsHidden ? plus.fadeOut(duration: 0.2) : plus.fadeIn(duration: 0.2)
        }
    }
    
    var isTheFirstCell: Bool = false {
        
        didSet {
            
            if isTheFirstCell {arrow.alpha = 0} else {arrow.alpha = 1}
            
        }
    }
    
    var canBeMoved: Bool = true {
        
        didSet {
            
        }
    }
    
    
    var canBeDeleted: Bool = true {
        
        didSet {
        
        }
    }
    
    
    //MARK: - Controls
    
    var isSetToEditingMode = false {
        didSet {
            
            !isTheFirstCell ? (arrowIsHidden = isSetToEditingMode) : (arrowIsHidden = true)
            
            titleIsSelected = false
                        
            if canBeDeleted {
                
                lockIsHidden = true
                xIsHidden = !isSetToEditingMode
                
            } else {
                
                lockIsHidden = !isSetToEditingMode
                xIsHidden = true
            }

            plusIsHidden = !isSetToEditingMode
            isSetToEditingMode ? self.main.shakeOn() : self.main.shakeOff()
        }
    }
    
    var isSetToRearrangeMode = false {
        didSet {
            
            if isSetToRearrangeMode {
                xIsHidden = true
                plusIsHidden = true
                lockIsHidden = canBeMoved
            }
        }
    }
    
    
    //MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        doInitialCalculations()
        
        configureCellStyle()
        configureTitleView()
        configureArrowView()
        configureXView()
        configureLockView()
        configurePlusView()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }
    
    
    
    override var isSelected: Bool {
       
        didSet {
            
            isSetToEditingMode ? () : (
                isSelected ? (theTitle.textColor = titleSelectedTextColor) : (theTitle.textColor = titleDeselectedTextColor)
            )
            //ToDo: - send delegate!
        }
    }

    
    //MARK: - Cell styles
    
    func configureCellStyle(){
        
        self.backgroundColor = .clear //.blue // .clear
        self.clipsToBounds = false
    }
    
    
    //MARK: - Elements view configuration
    
    func configureTitleView() {
        
        theTitle.font = titleFont
        theTitle.textColor = titleDeselectedTextColor
    }
    
    
    func configureArrowView() {
        
        arrow.text = "❭"
    }

    
    func configureXView() {
        
        x.layer.shadowColor = xShadowColor.cgColor
        x.layer.shadowOffset = xShadowOffset
        x.layer.shadowRadius = xShadowRadius
        x.layer.shadowOpacity = xShadowOpacity
    }
    
    
    func configureLockView() {
        
        lock = lock.shaded as! UIButton
    }

    
    func configurePlusView() {
        
    }
    
    //MARK: - Instruments
    
    func getCellSize (fromText text: String?, withHeight height: CGFloat) -> CGSize {
        
        var cellSize = CGSize()
        
        if let textToCalculate = text {
        
            // We can have multiple words of the equal characters count but different width when the font is applied
            
            let maxWordsCharacterCount = textToCalculate.maxWord.characters.count
            let allLongWords: [String] = textToCalculate.wordList.filter {$0.characters.count == maxWordsCharacterCount}
            
            var sizes: [CGFloat] = []
            
            let textAttributes = [
                NSFontAttributeName: titleFont
            ]
            
            allLongWords.forEach {sizes.append($0.size(attributes: textAttributes).width)}
            
            cellSize = CGSize(width: (sizes.max()! + constantElementsWidth), height: height)
            
        } else {
            
            cellSize = CGSize(width: constantElementsWidth, height: height)
        }
        
        return cellSize
    }
    
    
    //MARK: - Actions
    
    @IBAction func xButtonPressed(_ sender: Any) {
        
        print ("\((object?.order ?? -1)): Should be deleted")
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        
        print ("Insert task before \((object?.order ?? -1))")
    }
    
    @IBAction func lockButtonPressed(_ sender: Any) {
        
        print ("It's locked \((object?.order ?? -1))")
    }
    
}
