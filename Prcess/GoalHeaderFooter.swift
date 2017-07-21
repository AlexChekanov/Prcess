//
//  GoalFooter.swift
//  Prcess
//
//  Created by Alexey Chekanov on 7/8/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit

class GoalFooter: UICollectionReusableView {
    
    //Mark: - @IBOutlets
    
    @IBOutlet private weak var theTitle: UILabel!
    @IBOutlet private weak var arrow: UILabel!
    @IBOutlet private weak var x: UIButton!
    @IBOutlet private weak var plus: UIButton!
    
    @IBOutlet private weak var main: UIView!
    @IBOutlet private weak var service: UIView!
    
    
    //Mark: - Variables
    
    let constantElementsWidth: CGFloat = 65
    
    
    
    //MARK: - Initialization
    
    func cleanUp(){
        
        title = nil
        main.shakeOff()
    }
    
    
    //Mark: - Initial Calculations
    
    func doInitialCalculations() {
    }
    
    
    //MARK: - Inputs
    
    var object: Goal? = nil {
        
        didSet {
            
            if object != nil {
                title = object?.title
                
                if let taskCount = object?.tasks?.count {
                    
                    taskCount>0 ? (hasAnyTask = true) : (hasAnyTask = false)
                } else { hasAnyTask = false }
                
            } else {
                hasAnyTask = false
            }
        }
        
    }
    
    var title: String? = nil {
        didSet {
            theTitle.text = title
        }
    }
    let titleFont: UIFont = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBlack)
    var titleTextColor: UIColor = .orange
    
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
    
    var plusTintColor: UIColor = .lightGray
    var plusIsHidden: Bool = false {
        didSet {
            plusIsHidden ? plus.fadeOut(duration: 0.2) : plus.fadeIn(duration: 0.2)
        }
    }
    
    var hasAnyTask: Bool = false {
        
        didSet {
            arrowIsHidden = !hasAnyTask
        }
    }
    
    //MARK: - Controls
    
    var isSetToEditingMode = false {
        didSet {
            
            xIsHidden = !isSetToEditingMode
            plusIsHidden = !isSetToEditingMode
            hasAnyTask ? (arrowIsHidden = isSetToEditingMode) : (arrowIsHidden = true)
            isSetToEditingMode ? self.main.shakeOn() : self.main.shakeOff()
        }
    }
    
    var isSetToRearrangeMode = false {
        didSet {
            
            if isSetToRearrangeMode {
                xIsHidden = true
                plusIsHidden = true
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
        configurePlusView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }
    
    
    
    //MARK: - Cell styles
    
    func configureCellStyle(){
        
        self.backgroundColor = .clear
        self.clipsToBounds = false
    }
    
    
    //MARK: - Elements view configuration
    
    func configureTitleView() {
        
        theTitle.font = titleFont
        theTitle.textColor = titleTextColor
    }
    
    
    func configureArrowView() {
        
        arrow.text = "❭"
    }
    
    
    func configureXView() {
        
        x.shadowStyle = Shadow.soft
    }
    
    
    func configurePlusView() {
        
    }
    
    //MARK: - Instruments
    
    func getFooterSize (fromText text: String?, withHeight height: CGFloat) -> CGSize {
        
        var footerSize = CGSize()
        
        if text != nil {
            
            let textToCalculate = text!
            
            // We can have multiple words of the equal characters count but different width when the font is applied
            
            let maxWordsCharacterCount = textToCalculate.longestWord.characters.count
            let allLongWords: [String] = textToCalculate.wordList.filter {$0.characters.count == maxWordsCharacterCount}
            
            var sizes: [CGFloat] = []
            
            let textAttributes = [
                NSFontAttributeName: titleFont
            ]
            
            allLongWords.forEach {sizes.append($0.size(attributes: textAttributes).width)}
            
            footerSize = CGSize(width: (sizes.max()! + 1.5*constantElementsWidth), height: height)
            
        } else {
            
            footerSize = CGSize(width: 1.5*constantElementsWidth, height: height)
        }
        
        return footerSize
    }
    
    
    //MARK: - Actions
    
    @IBAction func xButtonPressed(_ sender: Any) {
        
        print ("The Goal should be deleted")
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        
        print ("Insert task before the completiom")
    }
    
}


//MARK: - Header

class GoalHeader: UICollectionReusableView {
    
    //MARK: - Controls
    
    var isSetToEditingMode = false {
        didSet {
        }
    }
    
    var isSetToRearrangeMode = false {
        didSet {
        }
    }
}
