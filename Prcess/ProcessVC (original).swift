//
//  ProcessVC.swift
//  Prcess
//
//  Created by Alexey Chekanov on 7/3/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import UIKit

private let reuseCellIdentifier = "Step"
private let reuseFooterIdentifier = "Goal"

//

public protocol YJWaterLayoutModelable {
    var size: CGSize {get}
}



//


struct ItemLayout: YJWaterLayoutModelable {
    var size: CGSize
}



class ProcessVC: UICollectionViewController, UIGestureRecognizerDelegate {
    
    var datas: [YJWaterLayoutModelable] = [YJWaterLayoutModelable]()
    
    enum CollectionState {
        case normal
        case editing
        case rearrangement
        
        mutating func next() {
            switch self {
            case .normal:
                self = .editing
            case .editing:
                self = .rearrangement
            case .rearrangement:
                self = .normal
            }
        }
    }
    
    // MARK: - Variables
    
    var collectionState: CollectionState = .normal {
        
        didSet {
            setCollectionViewMode()
        }
    }
    
    var layoutCache = [IndexPath : CGSize]()
    
    let lpgr = UILongPressGestureRecognizer()
    
    
    // MARK: - Inputs
    
    // Mark: - Outputs
    
    // MARK: - CleanUp
    
    func cleanUp() {
        layoutCache.removeAll()
    }
    
    // MARK: - Initialization
    
    let data = Data()
    var tasks: [Task]? = []
    var goal = Goal (title: nil, state: Goal.State.running, tasks: [])
    
    
    // MARK: - Data check
    
    func dataExists() -> Bool {
        
        guard (data.currentGoal != nil) else { return false }
        
        return true
    }
    
    
    // MARK: - Settings
    
    func setting() {
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        self.definesPresentationContext = false
        self.clearsSelectionOnViewWillAppear = true
    }
    
    func getData() {
        
        goal = data.currentGoal!
        tasks = data.currentGoal?.tasks
        
        guard let height = self.collectionView?.contentSize.height else { return }
        let cellHeight = 0.8*height
        print (cellHeight)
        
        //Get sizes
        tasks?.forEach {
            
            let cell = StepCell()
            let text = $0.title
            
            let cellWidth = cell.getCellSize(fromText: text, withHeight: cellHeight).width
            
            datas.append(ItemLayout(size: CGSize(width: cellWidth, height: cellHeight)))
        }
    }
    
    
    // MARK: - Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard dataExists() else {
            
            print ("There is no data")
            return
        }
        
        //self.collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView?.sizeToFit()
        
        self.getData()
        self.setting()
        self.cleanUp()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        addLongPressObserver()
    }
    
    func addLongPressObserver() {
        lpgr.addTarget(self, action: #selector(handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = false
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    // MARK: - Gestures handeling
    
    var selectedCellCenter = CGPoint.zero
    var gestureFirstPoint = CGPoint.zero
    
    var δX: CGFloat = 0.0
    var δY: CGFloat = 0.0
    
    func handleLongPress(_ gesture: UILongPressGestureRecognizer){
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            
            collectionState.next()
            
            guard collectionState == .rearrangement else { break }
            
            guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else { break }
            
            selectedCellCenter = (collectionView?.layoutAttributesForItem(at: selectedIndexPath)?.center)!
            gestureFirstPoint = gesture.location(in: self.collectionView)
            
            δX = selectedCellCenter.x - gestureFirstPoint.x
            δY = selectedCellCenter.y - gestureFirstPoint.y
            
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
            
            
        case UIGestureRecognizerState.changed:
            
            guard collectionState == .rearrangement else { break }
            
            let newPoint = CGPoint(x: (gesture.location(in: gesture.view!).x + δX), y: (gesture.location(in: gesture.view!).y + δY))
            
            collectionView?.updateInteractiveMovementTargetPosition(newPoint)
            
            
        case UIGestureRecognizerState.ended:
            
            collectionView?.endInteractiveMovement()
            
            guard collectionState == .rearrangement else { break }
            
            performBatchUpdates()
            
            collectionState = .normal
            
            δX = 0.0
            δY = 0.0
            
        default:
            
            collectionView?.cancelInteractiveMovement()
            
        }
    }
    
    
    // MARK: - Collection elements
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if let numbersOfItems = tasks?.count {
            
            return numbersOfItems
            
        } else {
            
            return 0
        }
    }
    
    
    // MARK: - Cells (Represent Steps)
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! StepCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? StepCell else { return }
        if indexPath.row == 0 { cell.isTheFirstCell = true } else { cell.isTheFirstCell = false }
        
        cell.object = tasks?[indexPath.row]
        cell.cellState = collectionState
    }
    
    
    // MARK: - Footer (Represents Goal)
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseFooterIdentifier, for: indexPath) as! GoalFooter
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let view = view as? GoalFooter else { return }
        
        view.object = goal
        view.viewState = collectionState
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = (collectionView.cellForItem(at: indexPath) as? StepCell) else { return }
        cell.updateTitle()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = (collectionView.cellForItem(at: indexPath) as? StepCell) else { return }
        cell.updateTitle()
    }
    
    // MARK: - UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    //MARK: - Memory Management
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
}


// MARK: - Layout

extension ProcessVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard datas.count > 0 else { return CGSize.zero }
        
        return CGSize(width: datas[indexPath.item].size.width, height: datas[indexPath.item].size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard ((self.collectionView?.frame.height) != nil) else { return CGSize.zero }
        
        let footerHeight = (self.collectionView?.bounds.height)!*0.8
        let footer = GoalFooter()
        let footerSize: CGSize = footer.getFooterSize(fromText: goal.title, withHeight: footerHeight)
        
        return footerSize
    }
}


// MARK: - Reorder

extension ProcessVC {
    
    // Chek if the cell is movable
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        guard let cell = (collectionView.cellForItem(at: indexPath) as? StepCell) else  { return false }
        
        return cell.canBeMoved
    }
    
    // Perform move action
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath,
                                 to destinationIndexPath: IndexPath) {
        
        if #available(iOS 9.0, *) {
            
            if self.lpgr.state == .ended {
                return
            }
            
            //In case the movable cell jumps over several cells we have to recalculate sizes
            if abs(sourceIndexPath.row - destinationIndexPath.row) > 1 {
                self.layoutCache.removeAll()
            } else {
                layoutCache[sourceIndexPath] = nil
                layoutCache[destinationIndexPath] = nil
            }
            
            //Update external data
            data.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
            
            
            //Update internal data
            tasks = (data.currentGoal?.tasks)!
        }
    }
}

extension UICollectionViewFlowLayout {
    
    @available(iOS 9.0, *)
    open override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
        
        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
        
        if previousIndexPaths.first!.row != targetIndexPaths.first!.row {
            collectionView?.dataSource?.collectionView?(collectionView!, moveItemAt: previousIndexPaths.first!, to: targetIndexPaths.last!)
        }
        
        return context
    }
    
    open override func invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths indexPaths: [IndexPath], previousIndexPaths: [IndexPath], movementCancelled: Bool) -> UICollectionViewLayoutInvalidationContext {
        
        return super.invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths: indexPaths, previousIndexPaths: previousIndexPaths, movementCancelled: movementCancelled)
    }
    
    @available(iOS 9.0, *)
    open override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        
        attributes.alpha = 0.6
        
        return attributes
    }
}


// MARK: - Rotation

extension ProcessVC {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            
            self.resignFirstResponder()
            if (self.collectionState == .rearrangement) { self.collectionState = .normal }
            self.layoutCache.removeAll()
            self.collectionViewLayout.invalidateLayout()
            self.performBatchUpdates()
            self.setCollectionViewMode()
        })
    }
}

extension UICollectionViewFlowLayout {
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = collectionView?.bounds
        if newBounds.width != oldBounds?.width {
            
            return true
        }
        return false
    }
}


// Mark: - Service methods

extension ProcessVC {
    
    
    func performBatchUpdates() {
        
        self.collectionView?.performBatchUpdates(
            { self.collectionView?.reloadSections(NSIndexSet(index: 0) as IndexSet)
        }, completion: { (finished:Bool) -> Void in
            
        })
    }
    
    
    func setCollectionViewMode() {
        
        collectionView?.visibleCells.forEach {
            let cell = $0 as! StepCell
            cell.cellState = collectionState
        }
        
        collectionView?.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).forEach {
            let footer = $0 as! GoalFooter
            footer.viewState = collectionState
        }
        
        collectionView?.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader).forEach {
            let header = $0 as! GoalHeader
            header.viewState = collectionState
        }
    }
}

