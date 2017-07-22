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
    
    let constantElementsWidth: CGFloat = 65
    
    //Style
    let attentionColor = UIColor.orange.withAlphaComponent(0.8)
    let denialColor = UIColor.red.withAlphaComponent(0.8)
    let neutralAction = UIColor.white.withAlphaComponent(0.8)
    
    
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
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (object?.title ?? "")!)
                attributeString.applyAttributes(ofStyle: TextStyle.stamp)
                
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
    
    let titleFont: UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3)
    
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
    
    
    var xIsHidden: Bool = false {
        didSet {
            xIsHidden ? x.fadeOut(duration: 0.2) : x.fadeIn(duration: 0.2)
        }
    }
    
    
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
            
            isTheFirstCell ? (arrow.alpha = 0) : (arrow.alpha = 1)
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
        
        self.backgroundColor = .clear
        self.clipsToBounds = false
    }
    
    
    //MARK: - Elements view configuration
    
    func configureTitleView() {
        
        theTitle.font = titleFont
        theTitle.textColor = titleDeselectedTextColor
        theTitle.adjustsFontForContentSizeCategory = true
    }
    
    
    func configureArrowView() {
        
        arrow.text = "❭"
    }
    
    
    func configureXView() {
        
        x.shadowStyle = Shadow.soft
        x.tintColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    
    func configureLockView() {
        
        lock.shadowStyle = Shadow.soft
        lock.tintColor = UIColor.red.withAlphaComponent(0.8)
    }
    
    
    func configurePlusView() {
        
    }
    
    //MARK: - Instruments
    
    func getCellSize (fromText text: String?, withHeight height: CGFloat) -> CGSize {
        
        var cellSize = CGSize(width: constantElementsWidth, height: height)
        
        if text != nil {
            
            let labelFromTheTextWithOptimalWidth = UILabel(text: text, font: titleFont, maximumHeight: height, lineBreakMode: NSLineBreakMode.byWordWrapping, constantElementsWidth: 0.0, acceptableWidthForTextOfOneLine: 120, textColor: nil, backgroundColor: nil, textAlignment: NSTextAlignment.natural, userInteractionEnabled: nil)
            
            cellSize.width += labelFromTheTextWithOptimalWidth.bounds.width
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
