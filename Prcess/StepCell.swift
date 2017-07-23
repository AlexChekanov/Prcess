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
    
    
    // MARK: - Controller
    
    enum CellState {
        case normal
        case editing
        case rearrangement
    }
    
    var cellState: CellState = .normal {
        didSet {
            switch self.cellState {
            case .normal: setCellToNormalMode()
            case .editing: setCellToEditingMode()
            case .rearrangement: setCellToRearrangementMode()
            }
        }
    }
    
    func setCellToNormalMode() {
        
        isTheFirstCell ? (arrowIsHidden = true) : (arrowIsHidden = false)
        lockIsHidden = true
        xIsHidden = true
        plusIsHidden = true
        self.main.shakeOff()
    }
    
    func setCellToEditingMode() {
        
        isSelected = false
        arrowIsHidden = true
        lockIsHidden = canBeDeleted
        xIsHidden = !canBeDeleted
        plusIsHidden = false
        self.main.shakeOn()
        
    }
    
    func setCellToRearrangementMode() {
        isSelected = false
        arrowIsHidden = true
        xIsHidden = true
        plusIsHidden = true
        lockIsHidden = canBeMoved
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
                
                title = NSMutableAttributedString(string: (object?.title ?? "")!)
                taskState = object?.state ?? .running
                canBeMoved = object?.canBeMoved ?? false
                canBeDeleted = object?.canBeDeleted ?? false
            }
        }
    }
    
    
    // MARK: - View
    
    
    let constantElementsWidth: CGFloat = 65
    
    
    // Styles
    
    let attentionColor = UIColor.orange.withAlphaComponent(0.8)
    let denialColor = UIColor.red.withAlphaComponent(0.8)
    let neutralAction = UIColor.white.withAlphaComponent(0.8)
    
    let textStyleForCalculations = TextStyle.taskHeadline.completed.selected.style
    let acceptableWidthForTextOfOneLine: CGFloat = 60.0
    
    
    // MARK: - Initialization
    
    func cleanUp(){
        
        cellState = .normal
        title = nil
        isTheFirstCell = false
        canBeMoved = false
        canBeDeleted = false
    }
    
    func doInitialCalculations() {
    }
    
    var title: NSMutableAttributedString? = nil {
        didSet {
            
            isSelected ? (title?.applyAttributes(ofStyle: selectedTextStyle)) :
                (title?.applyAttributes(ofStyle: deselectedTextStyle))
            theTitle.attributedText = title
        }
    }
    
    var arrowFont: UIFont = TextStyle.taskHeadline.running.deselected.style.font!
    var arrowTextColor: UIColor = TextStyle.taskHeadline.running.deselected.style.fontColor!
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
            let a = title
            title = a
        }
        
        //ToDo: - send delegate!
    }
    
    
    
    //MARK: - Cell styles
    
    func configureCellStyle(){
        
        self.backgroundColor = .clear
        self.clipsToBounds = false
    }
    
    
    //MARK: - Elements view configuration
    
    func configureTitleView() {
        
        theTitle.adjustsFontForContentSizeCategory = true
    }
    
    
    func configureArrowView() {
        
        arrow.text = "❭"
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
