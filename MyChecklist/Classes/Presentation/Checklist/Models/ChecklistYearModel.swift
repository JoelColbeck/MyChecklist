//
//  ChecklistYearModel.swift
//  MyChecklist
//
//  Created by Башир Арсланалиев on 09.10.2021.
//

import Foundation

struct ChecklistYearModel {
    let age: String
    let year: String
    let anchors: [ChecklistAnchorModel]
}

struct ChecklistAnchorModel {
    let title: String
    let category: String
    let importance: Importance
}
