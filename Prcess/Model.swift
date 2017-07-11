//
//  Model.swift
//  Prcess
//
//  Created by Alexey Chekanov on 7/3/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import Foundation

class Task: NSObject {

    var title: String = ""
    var order: Int = 0
    var isCompleted : Bool = false
    var canBeMoved: Bool = true
    var canBeDeleted: Bool = true
    
    init (title: String, order: Int, isCompleted: Bool, canBeMoved: Bool, canBeDeleted: Bool) {
        
        self.title = title
        self.order = order
        self.isCompleted = isCompleted
        self.canBeMoved = canBeMoved
        self.canBeDeleted = canBeDeleted
    }
}


class Goal {
    
    var title: String? = nil
    var isCompleted: Bool = false
    var tasks: [Task]? = nil

    
    init (title: String?, isCompleted: Bool, tasks: [Task]) {
        
        self.title = title
        self.isCompleted = isCompleted
        self.tasks = returnOrdered(tasks: tasks)
    }
    
    
    func returnOrdered (tasks: [Task]) -> [Task] {
        let sortedTasks = tasks.sorted {
            $0.order < $1.order
        }
        
        return sortedTasks
    }

    
}



class Data {
    
    var taskSet1: [Task]
    
    var taskSet2: [Task]
    
    var taskSet3: [Task]
    
    var goals: [Goal]
    
    var currentGoal: Goal?
    
    let currentGoalIndex: Int = 0
    
    init() {
       
        taskSet3 = [
            
            Task(title: "Check", order: 0, isCompleted: true, canBeMoved: true, canBeDeleted: false),
            Task(title: "Disassemble", order: 1, isCompleted: false, canBeMoved: true, canBeDeleted: true),
            Task(title: "Sell", order: 5, isCompleted: false, canBeMoved: false, canBeDeleted: true),
            Task(title: "Fix", order: 2, isCompleted: false, canBeMoved: true, canBeDeleted: true),
            Task(title: "Change", order: 3, isCompleted: false, canBeMoved: true, canBeDeleted: true),
            Task(title: "Assemble", order: 4, isCompleted: false, canBeMoved: true, canBeDeleted: true),
        ]

        
        taskSet1 = [
            
            Task(title: "Check the car", order: 0, isCompleted: true, canBeMoved: true, canBeDeleted: false),
            Task(title: "Disassemble the car", order: 1, isCompleted: false, canBeMoved: true, canBeDeleted: true),
            Task(title: "Sell", order: 5, isCompleted: false, canBeMoved: false, canBeDeleted: true),
            Task(title: "Fix repairable parts", order: 2, isCompleted: false, canBeMoved: true, canBeDeleted: true),
            Task(title: "Change unrepairable parts", order: 3, isCompleted: false, canBeMoved: true, canBeDeleted: true),
            Task(title: "Assemble the car", order: 4, isCompleted: false, canBeMoved: true, canBeDeleted: true),
        ]

        taskSet2 = []
        
        goals = [
            
            Goal(title: "Get rid of the car", isCompleted: false, tasks: taskSet1),
            Goal(title: "Aerocomic goal", isCompleted: false, tasks: taskSet2),
            Goal(title: nil, isCompleted: true, tasks: taskSet2)
        ]
        
        currentGoal = goals[currentGoalIndex]
    }
    
    
    func moveItem(at fromIndex: Int, to toIndex: Int) {
        
        
        //tasks = returnOrdered()
        
        let task = currentGoal?.tasks?.remove(at: fromIndex)
        currentGoal?.tasks?.insert(task!, at: toIndex)
        
        reorder()
    }
    
    
    func reorder() {
        
        
        for (index, task) in (currentGoal?.tasks?.enumerated())! {
            
            task.order = index
            
        }
        
    }
}

