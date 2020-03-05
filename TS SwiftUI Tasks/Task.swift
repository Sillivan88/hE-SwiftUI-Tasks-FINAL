//
//  Task.swift
//  TS SwiftUI Tasks
//
//  Created by Thomas Sillmann on 27.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import Foundation

class Task: ObservableObject, Identifiable {
    
    enum Priority: Int, CaseIterable {
        case `default`
        case high
        
        var formattedTitle: String {
            switch self {
            case .`default`:
                return "Default"
            case .high:
                return "High"
            }
        }
    }
    
    var id = UUID()
    
    @Published var title: String
    
    @Published var priority: Priority
    
    @Published var deadline: Date?
    
    @Published var notes: String?
    
    @Published var isFinished: Bool
    
    var formattedDeadline: String {
        if let deadline = self.deadline {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: deadline)
        }
        return "No deadline"
    }
    
    init(title: String, priority: Priority = .default, deadline: Date? = nil, notes: String? = nil, isFinished: Bool = false) {
        self.title = title
        self.priority = priority
        self.deadline = deadline
        self.notes = notes
        self.isFinished = isFinished
    }
    
}

class TaskManager: ObservableObject {
    
    static let shared = TaskManager()
    
    @Published var tasks: [Task]
    
    var tasksSortedByTitle: [Task] {
        tasks.sorted { (firstTask, secondTask) -> Bool in
            firstTask.title < secondTask.title
        }
    }
    
    var tasksSortedByPriority: [Task] {
        tasksSortedByTitle.sorted { (firstTask, secondTask) -> Bool in
            firstTask.priority.rawValue > secondTask.priority.rawValue
        }
    }
    
    var defaultPriorityTasksAvailable: Bool {
        (tasks.first { (task) -> Bool in
            task.priority == .default
            } != nil)
    }
    
    var highPriorityTasksAvailable: Bool {
        (tasks.first { (task) -> Bool in
            task.priority == .high
            } != nil)
    }
    
    init(tasks: [Task] = [Task]()) {
        self.tasks = tasks
    }
    
    func createNewTask(withTitle title: String, priority: Task.Priority = .default, deadline: Date? = nil, notes: String? = nil, isFinished: Bool = false) {
        let task = Task(title: title, priority: priority, deadline: deadline, notes: notes, isFinished: isFinished)
        tasks.append(task)
    }
    
    func deleteTask(_ task: Task) {
        self.tasks.removeAll { (foundTask) -> Bool in
            foundTask.id == task.id
        }
    }
    
}

let testTasks = [
    Task(title: "Workshop vorbereiten", priority: .high),
    Task(title: "Workshop durchführen", priority: .high),
    Task(title: "Swift-Artikel schreiben")
]
