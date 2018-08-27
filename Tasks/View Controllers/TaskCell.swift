//
//  TaskCell.swift
//  Tasks
//
//  Created by Simon Elhoej Steinmejer on 27/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
//    override var isHighlighted: Bool
//    {
//        didSet
//        {
//            self.backgroundColor = isHighlighted ? Appearance.myBlueColor : Appearance.backgroundColor
//        }
//    }
//    
//    override var isSelected: Bool
//    {
//        didSet
//        {
//            self.backgroundColor = isSelected ? Appearance.myBlueColor : Appearance.backgroundColor
//        }
//    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        setupLabels()
    }
    
    private func setupLabels()
    {
        titleLabel.font = Appearance.appFont(with: .title2, size: 16)
        noteLabel.font = Appearance.appFont(with: .title3, size: 12)
    }

}
