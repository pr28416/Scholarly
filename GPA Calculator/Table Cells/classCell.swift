//
//  classCell.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 2/6/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//

import UIKit

class classCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return possibleGrades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return possibleGrades[row]
    }
    
    var possibleGrades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    @IBOutlet var classNameField: UITextField!
    @IBOutlet var classType: UILabel!
    
    @IBOutlet var numberRow: UILabel!
    @IBOutlet var creditControl: UIStepper!
    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var creditNum: UILabel!
    
    @IBOutlet var blackOverlay: UIView!
    @IBOutlet var pickerImage: UIImageView!
    @IBOutlet var backImage: UIImageView!
    
    var typeList = ["College Prep", "Honors", "AP", "IB"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numberRow.layer.masksToBounds = true
        pickerView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
