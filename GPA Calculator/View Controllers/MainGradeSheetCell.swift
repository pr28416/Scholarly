//
//  MainGradeSheetCell.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/25/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class MainGradeSheetCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var dateModified: UILabel!
    @IBOutlet weak var gpa: UILabel!
    @IBOutlet weak var weightedTitle: UILabel!
    var gradeSheet: GradeSheet!
}
