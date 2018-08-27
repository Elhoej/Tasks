//
//  ViewController.swift
//  Tasks
//
//  Created by Simon Elhoej Steinmejer on 13/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    lazy var fetchedResultsController: NSFetchedResultsController<Task> =
    {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "priority", cacheName: nil)
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
    }()
    
    private let taskController = TaskController()
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = Appearance.backgroundColor
        tableView.backgroundColor = Appearance.backgroundColor
        tableView.tableHeaderView?.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
        tableView.separatorInset = .zero
        let navigationImageView = UIImageView(image: #imageLiteral(resourceName: "tasks-logo").withRenderingMode(.alwaysTemplate))
        navigationImageView.contentMode = .scaleAspectFit
        navigationImageView.tintColor = .white
        navigationItem.titleView = navigationImageView
    }
    
    //MARK: - Fetched Results Controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        switch type
        {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type
        {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: - Table view delegate/datasource
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        cell.backgroundColor = Appearance.myBlueColor
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        cell.backgroundColor = Appearance.backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        cell.backgroundColor = Appearance.myBlueColor
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        cell.backgroundColor = Appearance.backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return fetchedResultsController.sections?[section].name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        let task = fetchedResultsController.object(at: indexPath)
        
        cell.titleLabel.text = task.name
        cell.noteLabel.text = task.notes
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let task = fetchedResultsController.object(at: indexPath)
            let moc = CoreDataStack.shared.mainContext
            moc.delete(task)
            
            do
            {
                try moc.save()
            } catch
            {
                moc.reset()
            }
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showTaskDetail"
        {
            let detailVC = segue.destination as! TaskDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow
            {
                detailVC.task = fetchedResultsController.object(at: indexPath)
                detailVC.taskController = self.taskController
            }
            
            if segue.identifier == "showCreateTask"
            {
                detailVC.taskController = self.taskController
            }
        }
    }
    
}

extension String
{
    func capitalizingFirstLetter() -> String
    {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter()
    {
        self = self.capitalizingFirstLetter()
    }
}




















