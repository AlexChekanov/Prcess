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

class ProcessVC: UICollectionViewController, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    
    var isSetToEditingMode: Bool = false {
        
        didSet {
            
            collectionView?.visibleCells.forEach {
                
                let cell = $0 as! StepCell
                
                cell.isSetToEditingMode = isSetToEditingMode
            
            
            }
            
            collectionView?.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).forEach {
                
                let footer = $0 as! GoalFooter
                
                footer.isSetToEditingMode = isSetToEditingMode
            }
        }
    }
    
    
    var isSetToRearrangeMode: Bool = false {
        
        didSet {
            
            collectionView?.visibleCells.forEach {
                
                let cell = $0 as! StepCell
                
                cell.isSetToRearrangeMode = isSetToRearrangeMode
            }
            
            collectionView?.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).forEach {
                
                let footer = $0 as! GoalFooter
                
                footer.isSetToRearrangeMode = isSetToRearrangeMode
            }
        }
    }

    
    // MARK: - Inputs
    

    
    // Mark: - Outputs
    
    

    // MARK: - CleanUp
    
    func cleanUp() {
        
        isSetToEditingMode = false
        isSetToRearrangeMode = false
    }

    
    // MARK: - Initialization
    
    let data = Data()
    var tasks: [Task]? = []
    var goal = Goal(title: nil, isCompleted: false, tasks: [])
    
    
    // MARK: - Data check
    
    func dataExists() -> Bool {
        
        guard (data.currentGoal != nil) else { return false }
        
        return true
    }
    
    
    // MARK: - Settings
    
    func setting() {
    
        collectionView?.dataSource = self
        collectionView?.delegate = self
     }
    
    
    // MARK: - Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setting()
        self.cleanUp()
        
        
        guard dataExists() else {
        
            print ("There is no data")
            return
        }
        
        goal = data.currentGoal!
        
        tasks = data.currentGoal?.tasks
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        addLongPressObserver()
    }
    
    func addLongPressObserver() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = false
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    // MARK: - Gestures handeling

    func handleLongPress(_ gesture: UILongPressGestureRecognizer){
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            
            
            if isSetToEditingMode {
                
                if isSetToRearrangeMode {
                    
                    isSetToEditingMode = false
                    isSetToRearrangeMode = false
                    

                } else {
                
                    
                    isSetToRearrangeMode = true
                    
                }
                
                
            } else {
                isSetToEditingMode = true
            }
            
            guard isSetToRearrangeMode else { break }
            
            guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }

            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
            
            
        case UIGestureRecognizerState.changed:
            
            isSetToRearrangeMode ? collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!)) : ()
        
        case UIGestureRecognizerState.ended:
            
            
            collectionView?.endInteractiveMovement()
            
            
            if isSetToRearrangeMode {
                
                self.collectionView?.performBatchUpdates(
                    {
                        self.collectionView?.reloadSections(NSIndexSet(index: 0) as IndexSet)
                }, completion: { (finished:Bool) -> Void in
                })
                
                isSetToRearrangeMode = false
                isSetToEditingMode = false
                
            }
            
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
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! StepCell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? StepCell else { return }
        
        cell.object = tasks?[indexPath.row]
        
        isSetToEditingMode ? (cell.isSetToEditingMode = true) : (cell.isSetToEditingMode = false)
        isSetToRearrangeMode ? (cell.isSetToRearrangeMode = true) : (cell.isSetToRearrangeMode = false)
        
        if indexPath.row == 0 {cell.isTheFirstCell = true} else {cell.isTheFirstCell = false}
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        guard let cell = (collectionView.cellForItem(at: indexPath) as? StepCell) else  { return false }
        
        return cell.canBeMoved
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath,
                                 to destinationIndexPath: IndexPath) {
        
        //Update external data
        data.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
        
        
        //Update internal data
        tasks = (data.currentGoal?.tasks)!
        
        print ("---")
        tasks?.forEach {print ("\($0.order): \($0.title)")}
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let cellHeight = (self.collectionView?.bounds.height)!*0.8
        
        let cell = StepCell()
        let text = tasks?[indexPath.row].title
        
        let cellSize: CGSize = cell.getCellSize(fromText: text, withHeight: cellHeight)
        
        return cellSize
    }

    
    // MARK: - Footer (Represents Goal)
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseFooterIdentifier, for: indexPath) as! GoalFooter
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let view = view as? GoalFooter else { return }
        
        view.object = goal
        
        isSetToEditingMode ? (view.isSetToEditingMode = true) : (view.isSetToEditingMode = false)
        isSetToRearrangeMode ? (view.isSetToRearrangeMode = true) : (view.isSetToRearrangeMode = false)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard ((self.collectionView?.frame.height) != nil) else { return CGSize.zero }
        
        let footerHeight = self.collectionView?.bounds.height
        
        let footer = GoalFooter()
        
        let footerSize: CGSize = footer.getFooterSize(fromText: goal.title, withHeight: footerHeight!)
        
        return footerSize
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

extension UICollectionViewFlowLayout {

    override open func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath],
                                                                 withTargetPosition targetPosition: CGPoint,
                                                                 previousIndexPaths: [IndexPath],
                                                                 previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
        
        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths as [IndexPath],
                                                                           withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths as [IndexPath],
        
                                                                           previousPosition: previousPosition)
        
        //collectionView?.moveItem(at: previousIndexPaths[0], to: targetIndexPaths[0])
        
        
        //self.delegate?.collectionView!(self.collectionView!, moveItemAt: previousIndexPaths[0], to: targetIndexPaths[0])
        
        return context
    }
}


//
//
//extension UICollectionViewFlowLayout {
//    
//    override open func shouldInvalidateLayout (forBoundsChange newBounds : CGRect) -> Bool {
//        let oldBounds = self.collectionView?.bounds
//        if newBounds.width != oldBounds?.width{
//            return true
//        }
//        return false
//    }
//    
//
//}


