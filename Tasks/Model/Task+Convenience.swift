//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Simon Elhoej Steinmejer on 13/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

enum TaskPriority: String
{
    case low
    case medium
    case high
    case critical
    
    static var allPriorities: [TaskPriority]
    {
        return [.low, .medium, .high, .critical]
    }
}


extension Task
{
    var taskRepresentation: TaskRepresentation?
    {
        guard let name = name, let notes = notes, let priority = priority else { return nil }
        
        return TaskRepresentation(name: name, notes: notes, priority: priority, identifier: self.identifier?.uuidString ?? "")
    }
    
    convenience init(name: String, notes: String? = nil, priority: TaskPriority = .medium, identifier: UUID = UUID(), managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(context: managedObjectContext)
        
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue
        self.identifier = identifier
    }
    
    convenience init?(taskRepresentation: TaskRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        guard let priority = TaskPriority(rawValue: taskRepresentation.priority), let identifier = UUID(uuidString: taskRepresentation.identifier) else { return nil}
        
        self.init(name: taskRepresentation.name, notes: taskRepresentation.notes, priority: priority, identifier: identifier, managedObjectContext: context)
    }
}







