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
    
    
    // MARK: - Controller
    
    var viewState: ProcessVC.CollectionState = .normal {
        didSet {
            switch self.viewState {
            case .normal: setViewToNormalMode()
            case .editing: setViewToEditingMode()
            case .rearrangement: setViewToRearrangementMode()
            }
        }
    }
    
    func setViewToNormalMode() {
        
        self.main.shakeOff()
        xIsHidden = true
        plusIsHidden = true
        hasAnyTask ? (arrowIsHidden = false) : (arrowIsHidden = true)
    }
    
    func setViewToEditingMode() {
        
        self.main.shakeOn()
        xIsHidden = false
        plusIsHidden = false
        arrowIsHidden = true
    }
    
    func setViewToRearrangementMode() {
        
        xIsHidden = true
        plusIsHidden = true
        arrowIsHidden = true
    }
    
    var goalState: Goal.State = .running {
        
        didSet {
            
            switch self.goalState {
            case .planned:
                textStyle = TextStyle.goalHeadline.planned.style
            case .running:
                textStyle = TextStyle.goalHeadline.running.style
            case .suspended:
                textStyle = TextStyle.goalHeadline.suspended.style
            case .completed:
                textStyle = TextStyle.goalHeadline.completed.style
            case .canceled:
                textStyle = TextStyle.goalHeadline.canceled.style
            }
        }
    }
    
    var textStyle: TextStyle = TextStyle.goalHeadline.running.style
    
    
    //MARK: - Inputs
    
    var object: Goal? = nil {
        
        didSet {
            
            if object != nil {
                
                
                goalState = object?.state ?? .running
                title = NSMutableAttributedString(string: (object?.title ?? "")!)
                
                if let taskCount = object?.tasks?.count {
                    
                    taskCount>0 ? (hasAnyTask = true) : (hasAnyTask = false)
                } else { hasAnyTask = false }
                
            } else {
                hasAnyTask = false
            }
        }
        
    }
    
    var title: NSMutableAttributedString? = nil {
        didSet {
            
            title?.applyAttributes(ofStyle: textStyle)
            theTitle.attributedText = title
        }
    }
    
    func cleanUp(){
    }
    
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
    
    //MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureTitleView()
        configureArrowView()
        configureXView()
        configurePlusView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }
    
    
    //MARK: - Elements view configuration
    
    let constantElementsWidth: CGFloat = 103
    
    // Styles
    
    //let attentionColor = UIColor.orange.withAlphaComponent(0.8)
    let denialColor = UIColor.red.withAlphaComponent(0.8)
    let neutralAction = UIColor.white.withAlphaComponent(0.8)
    
    let textStyleForCalculations = TextStyle.goalHeadline.completed.style
    let acceptableWidthForTextOfOneLine: CGFloat = 60.0
    
    
    func configureTitleView() {
        
        theTitle.adjustsFontForContentSizeCategory = true
        self.sendSubview(toBack: theTitle)
    }
    
    
    func configureArrowView() {
        
        arrow.text = "❭"
        arrow.font = TextStyle.taskHeadline.running.deselected.style.font!
        arrow.textColor = TextStyle.taskHeadline.running.deselected.style.fontColor!
    }
    
    
    func configureXView() {
        
        x.tintColor = neutralAction.withAlphaComponent(0.8)
        x.shadowStyle = Shadow.soft
    }
    
    
    func configurePlusView() {
        
        plus.tintColor = neutralAction
        
    }
    
    //MARK: - Instruments
    
    func getFooterSize (fromText text: String?, withHeight height: CGFloat) -> CGSize {
        
        var footerSize = CGSize(width: constantElementsWidth, height: height)
        
        if text != nil {
            
            let labelFromTheTextWithOptimalWidth = UILabel(text: text, font: textStyleForCalculations.font, maximumHeight: height, lineBreakMode: textStyleForCalculations.lineBreakMode, constantElementsWidth: 0.0, acceptableWidthForTextOfOneLine: acceptableWidthForTextOfOneLine, textColor: nil, backgroundColor: nil, textAlignment: textStyleForCalculations.alignment, userInteractionEnabled: nil)
            
            footerSize.width += labelFromTheTextWithOptimalWidth.bounds.width
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
    
    var viewState: ProcessVC.CollectionState = .normal {
        didSet {
            switch self.viewState {
            case .normal: setViewToNormalMode()
            case .editing: setViewToEditingMode()
            case .rearrangement: setViewToRearrangementMode()
            }
        }
    }
    
    func setViewToNormalMode() {}
    func setViewToEditingMode(){}
    func setViewToRearrangementMode() {}
}
