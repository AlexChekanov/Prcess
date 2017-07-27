//
//  StepCell.swift
//  Prcess
//
//  Created by Alexey Chekanov on 7/3/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit

class StepCell: UICollectionViewCell {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var theTitle: UILabel!
    @IBOutlet private weak var arrow: UILabel!
    @IBOutlet private weak var x: UIButton!
    @IBOutlet private weak var plus: UIButton!
    @IBOutlet private weak var lock: UIButton!
    
    @IBOutlet private weak var main: UIView!
    @IBOutlet private weak var service: UIView!
    
    
    // MARK: - CleanUp
    
    func cleanUp(){
        
        title = nil
        x.alpha = 0
        plus.alpha = 0
        lock.alpha = 0
        arrow.alpha = 0
    }
    
    
    // MARK: - Controller
    
    var cellState: ProcessVC.CollectionState = .normal {
        didSet {
            switch self.cellState {
            case .normal: setCellToNormalMode()
            case .editing: setCellToEditingMode()
            case .rearrangement: setCellToRearrangementMode()
            }
        }
    }
    
    
    func setCellToNormalMode() {
        
        
        lock.alpha == 0 ? () : (lockIsHidden = true)
        x.alpha == 0 ? () : (xIsHidden = true)
        plus.alpha == 0 ? () : (plusIsHidden = true)
        isTheFirstCell ? (arrow.alpha = 0) : (
            arrow.alpha == 0 ? (arrowIsHidden = false) : ()
        )
        
        guard main.layer.animation(forKey: "bounce") != nil else { return }
        self.main.shakeOff()
    }
    
    func setCellToEditingMode() {
        
        isSelected ? (isSelected = false) : ()
        lockIsHidden = canBeDeleted
        xIsHidden = !canBeDeleted
        plus.alpha == 0  ? (plusIsHidden = false) : ()
        arrow.alpha == 0 ? () : (arrowIsHidden = true)
        
        guard main.layer.animation(forKey: "bounce") == nil else { return }
        self.main.shakeOn()
    }
    
    func setCellToRearrangementMode() {
        
        isSelected ? (isSelected = false) : ()
        lockIsHidden = canBeMoved
        x.alpha == 0 ? () : (xIsHidden = true)
        plus.alpha == 0 ? () : (plusIsHidden = true)
        arrow.alpha == 0 ? () : (arrowIsHidden = true)
        
        guard main.layer.animation(forKey: "bounce") == nil else { return }
        self.main.shakeOn()
    }
    
    var taskState: Task.State = .running {
        
        didSet {
            
            switch self.taskState {
            case .planned:
                deselectedTextStyle = TextStyle.taskHeadline.planned.deselected.style
                selectedTextStyle = TextStyle.taskHeadline.planned.selected.style
            case .running:
                deselectedTextStyle = TextStyle.taskHeadline.running.deselected.style
                selectedTextStyle = TextStyle.taskHeadline.running.selected.style
            case .suspended:
                deselectedTextStyle = TextStyle.taskHeadline.suspended.deselected.style
                selectedTextStyle = TextStyle.taskHeadline.suspended.selected.style
            case .completed:
                deselectedTextStyle = TextStyle.taskHeadline.completed.deselected.style
                selectedTextStyle = TextStyle.taskHeadline.completed.selected.style
            case .canceled:
                deselectedTextStyle = TextStyle.taskHeadline.canceled.deselected.style
                selectedTextStyle = TextStyle.taskHeadline.canceled.selected.style
            }
        }
    }
    
    var deselectedTextStyle: TextStyle = TextStyle.taskHeadline.running.deselected.style
    var selectedTextStyle: TextStyle = TextStyle.taskHeadline.running.selected.style
    
    
    // Input
    
    var object: Task? = nil {
        
        didSet {
            
            if object != nil {
                
                taskState = object?.state ?? .running
                canBeMoved = object?.canBeMoved ?? false
                canBeDeleted = object?.canBeDeleted ?? false
                title = NSMutableAttributedString(string: (object?.title ?? "")!)
            }
        }
    }
    
    var canBeMoved: Bool = true
    var canBeDeleted: Bool = true
    
    var title: NSMutableAttributedString? = nil {
        didSet {
            
            if isSelected && (cellState == .normal) {
                
                title?.applyAttributes(ofStyle: selectedTextStyle)
            } else {
                title?.applyAttributes(ofStyle: deselectedTextStyle)
            }
            
            theTitle.attributedText = title
        }
    }
    
    var isTheFirstCell: Bool = false {
        
        didSet {
            
            isTheFirstCell ? (arrow.alpha = 0) : (arrowIsHidden = false)
        }
    }
    
    
    // MARK: - Initialization
    
    var arrowIsHidden: Bool = false {
        didSet {
            arrowIsHidden ? arrow.fadeOutResized(duration: 0.2) : arrow.fadeInResized(duration: 0.2)
        }
    }
    
    var xIsHidden: Bool = true {
        didSet {
            xIsHidden ? x.fadeOutResized(duration: 0.2) : x.fadeInResized(duration: 0.2)
        }
    }
    
    var lockIsHidden: Bool = true {
        didSet {
            lockIsHidden ? lock.fadeOutResized(duration: 0.2) : lock.fadeInResized(duration: 0.2)
        }
    }
    
    var plusIsHidden: Bool = true {
        didSet {
            plusIsHidden ? plus.fadeOutResized(duration: 0.2) : plus.fadeInResized(duration: 0.2)
        }
    }
    
    
    //MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cleanUp()
        configureTitleView()
        configureXView()
        configureLockView()
        configurePlusView()
        configureArrowView()
    }
    
    override func prepareForReuse() {
        cleanUp()
    }
    
    override var isSelected: Bool {
        
        didSet {
            
            let a = title
            title = a
        }
        
        
        //ToDo: - send delegate!
    }
    
    
    // MARK: - Elements view configuration
    
    let constantElementsWidth: CGFloat = 63
    
    
    // Styles
    
    //let attentionColor = UIColor.orange.withAlphaComponent(0.8)
    let denialColor = UIColor.red.withAlphaComponent(0.8)
    let neutralAction = UIColor.white.withAlphaComponent(0.8)
    
    let textStyleForCalculations = TextStyle.taskHeadline.completed.selected.style
    let acceptableWidthForTextOfOneLine: CGFloat = 60.0
    
    
    func configureTitleView() {
        
        theTitle.adjustsFontForContentSizeCategory = true
    }
    
    func configureArrowView() {
        
        arrow.text = "❭"
        arrow.font = TextStyle.taskHeadline.running.deselected.style.font!
        arrow.textColor = TextStyle.taskHeadline.running.deselected.style.fontColor!
        arrow.adjustsFontForContentSizeCategory = true
    }
    
    func configureXView() {
        
        x.tintColor = neutralAction.withAlphaComponent(0.8)
        x.shadowStyle = Shadow.soft
    }
    
    func configureLockView() {
        
        lock.tintColor = denialColor.withAlphaComponent(0.8)
        lock.shadowStyle = Shadow.soft
    }
    
    func configurePlusView() {
        
        plus.tintColor = neutralAction
    }
    
    
    //MARK: - Instruments
    
    func getCellSize (fromText text: String?, withHeight height: CGFloat) -> CGSize {
        
        var cellSize = CGSize(width: constantElementsWidth, height: height)
        
        if text != nil {
            
            let labelFromTheTextWithOptimalWidth = UILabel(text: text, font: textStyleForCalculations.font, maximumHeight: height, lineBreakMode: textStyleForCalculations.lineBreakMode, constantElementsWidth: 0.0, acceptableWidthForTextOfOneLine: acceptableWidthForTextOfOneLine, textColor: nil, backgroundColor: nil, textAlignment: textStyleForCalculations.alignment, userInteractionEnabled: nil)
            
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
