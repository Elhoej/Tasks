//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by Simon Elhoej Steinmejer on 13/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController
{
    var task: Task?
    {
        didSet
        {
            updateViews()
        }
    }
    var taskController: TaskController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = Appearance.backgroundColor
        updateViews()
        setupAppearance()
    }
    
    private func setupAppearance()
    {
        titleTextField.font = Appearance.appFont(with: .caption1, size: 13)
        notesTextView.font = Appearance.appFont(with: .caption1, size: 13)
        notesTextView.layer.cornerRadius = 6
        notesTextView.keyboardAppearance = .dark
        
        titleLabel.font = Appearance.appFont(with: .title2, size: 20)
        priorityLabel.font = Appearance.appFont(with: .title2, size: 20)
        notesLabel.font = Appearance.appFont(with: .title2, size: 20)
    }
    
    private func updateViews()
    {
        guard isViewLoaded else { return }
        
        title = task?.name
        titleTextField.text = task?.name
        notesTextView.text = task?.notes
        
//        guard let priority = TaskPriority(rawValue: priorityString) else { return }
//        prioritySegmentedControl.selectedSegmentIndex = TaskPriority.allPriorities.index(of: priority)
    }
    
    @IBAction func save(_ sender: Any)
    {
        guard let name = titleTextField.text, !name.isEmpty else { return }
        let notes = notesTextView.text
        
        if let task = task
        {
            task.name = name
            task.notes = notes
            task.priority = TaskPriority.allPriorities[prioritySegmentedControl.selectedSegmentIndex].rawValue
            taskController?.put(task: task)
        }
        else
        {
            var priority: TaskPriority
            switch(prioritySegmentedControl.selectedSegmentIndex) {
            case 0:
                priority = TaskPriority.low
            case 1:
                priority = TaskPriority.medium
            case 2:
                priority = TaskPriority.high
            case 3:
                priority = TaskPriority.critical
            default:
                priority = TaskPriority.medium
            }
            let task = Task(name: name, notes: notes, priority: priority)
            taskController?.put(task: task)
        }
        
        do
        {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch
        {
            NSLog("Error saving: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
}













