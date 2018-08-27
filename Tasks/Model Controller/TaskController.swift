//
//  TaskController.swift
//  Tasks
//
//  Created by Simon Elhoej Steinmejer on 15/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://tasks-b6a43.firebaseio.com/")!

class TaskController
{
    typealias CompletionHandler = (Error?) -> ()
    
    init()
    {
        fetchTasksFromServer()
    }
    
    func fetchTasksFromServer(completion: @escaping CompletionHandler = {_ in })
    {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error
            {
                NSLog("Failed to fetch from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("failed to unwrap data from server")
                completion(NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let taskRepresentations = Array(try jsonDecoder.decode([String: TaskRepresentation].self, from: data).values)
                let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
                
                try self.updateTasks(with: taskRepresentations, context: backgroundMoc)
                
                completion(nil)
                
            } catch {
                NSLog("Failed to decode data to JSON: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    private func updateTasks(with representations: [TaskRepresentation], context: NSManagedObjectContext) throws
    {
        var error: Error?
        
        context.performAndWait {
            
            for taskRep in representations
            {
                guard let uuid = UUID(uuidString: taskRep.identifier) else { continue }
                
                let task = self.task(forUUID: uuid)
                
                if let task = task
                {
                    self.update(task: task, with: taskRep)
                }
                else
                {
                    let _ = Task(taskRepresentation: taskRep, context: context)
                }
            }
            
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
        
    }
    
    func put(task: Task, completion: @escaping CompletionHandler = {_ in })
    {
        let uuid = task.identifier ?? UUID()
        task.identifier = uuid
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = task.taskRepresentation else { completion(NSError()); return }
            representation.identifier = uuid.uuidString
            try CoreDataStack.shared.saveContext()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Failed to encode Task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in

            if let error = error
            {
                NSLog("Error PUTing task to server \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()
    }
    
    private func update(task: Task, with representation: TaskRepresentation)
    {
        task.name = representation.name
        task.notes = representation.notes
        task.priority = representation.priority
    }
    
    private func task(forUUID uuid: UUID) -> Task?
    {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching: \(error)")
            return nil
        }
    }
}










