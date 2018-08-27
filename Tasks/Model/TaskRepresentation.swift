//
//  TaskRepresentation.swift
//  Tasks
//
//  Created by Simon Elhoej Steinmejer on 15/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct TaskRepresentation: Codable
{
    var name: String
    var notes: String?
    var priority: String
    var identifier: String
}
