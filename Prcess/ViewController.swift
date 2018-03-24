import UIKit
import UIElements
import Styles

class ViewController: UIViewController {
    
    @IBOutlet weak var processControl: ProcessControl!
    
    var processClass = Process()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view.
        processControl.delegate = self
        processControl.datasource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        processControl.updateLayout()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ViewController: ProcessControlDataSource {
    
    var styleOfScript: TextStyle {
        return TextStyle.goalHeadline.running.style
    }
    
    func styleOfItems(for state: ProcessControlElementState) -> (deselected: TextStyle, selected: TextStyle) {
        switch state {
            
        case .planned:
            return (TextStyle.taskHeadline.planned.deselected.style, TextStyle.taskHeadline.planned.selected.style)
        case .running:
            return (TextStyle.taskHeadline.running.deselected.style,
                    TextStyle.taskHeadline.running.selected.style)
        case .suspended:
            return (TextStyle.taskHeadline.suspended.deselected.style,
                    TextStyle.taskHeadline.suspended.selected.style)
        case .completed:
            return (TextStyle.taskHeadline.completed.deselected.style,
                    TextStyle.taskHeadline.completed.selected.style)
        case .canceled:
            return (TextStyle.taskHeadline.canceled.deselected.style,
                    TextStyle.taskHeadline.canceled.selected.style)
        }
    }
    
    
    var process: ProcessControlScript {
        
        let steps: [ProcessStepToControl]? = processClass.currentGoal?.tasks?.flatMap {
            
            var state: ProcessControlElementState
            
            switch $0.state {
                
            case .planned:
                state = .planned
            case .running:
                state = .running
            case .suspended:
                state = .suspended
            case .completed:
                state = .completed
            case .canceled:
                state = .canceled
            }
            
            return ProcessStepToControl(title: $0.title, order: $0.order, state: state, movable: $0.canBeMoved, removable: $0.canBeDeleted)
        }
        
        var state: ProcessControlElementState {
            
            guard let processState = processClass.currentGoal?.state else { return .running }
            
            switch processState {
                
            case .planned:
                return .planned
            case .running:
                return .running
            case .suspended:
                return .suspended
            case .completed:
                return .completed
            case .canceled:
                return .canceled
            }
            
        }
        
        let process = ProcessToControl(title: processClass.currentGoal?.title, steps: steps)
        
        return process
    }
}

extension ViewController: ProcessControlDelegate {
    
    func addItemToEnd() {
        print("Item to the end should be added")
    }
    
    func addItemAt(at index: Int) {
        print("Item at index:\(index) should be added")
    }
    
    func removeItem(at index: Int) {
        print("Item at \(index) should be removed")
    }
    
    func rejectRemoval(at index: Int) {
        print("The removal of the #\(index) item is not allowed")
    }
    
    // Rearrangement
    func moveItem(at fromIndex: Int, to toIndex: Int) {
        processClass.moveItem(at: fromIndex, to: toIndex)
    }
}
