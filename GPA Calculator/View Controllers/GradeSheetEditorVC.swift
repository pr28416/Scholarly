//
//  GradeSheetEditorVC.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/20/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class GradeSheetEditorVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBAction func debugPrintClicked(_ sender: Any) {
        print(gradeSheet!)
    }
    
    /// Class name field changed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell = textField.superview?.superview?.superview as! GradeSheetCell
        cell.gradeItem.className = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }
    
    /// Class type segmented control changed
    @IBAction func classTypeChanged(_ sender: UISegmentedControl) {
        let cell = sender.superview?.superview?.superview as! GradeSheetCell
        switch sender.selectedSegmentIndex {
        case 0: cell.gradeItem.classType = .standard
        case 1: cell.gradeItem.classType = .honors
        case 2: cell.gradeItem.classType = .advanced
        default: break
        }
    }
    
    /// Credits stepper changed
    @IBAction func creditStepperChanged(_ sender: UIStepper) {
        let cell = sender.superview?.superview?.superview as! GradeSheetCell
        cell.gradeItem.credits = sender.value
        cell.creditLabel.text = "\(sender.value)"
    }
    
    /// Grade picker changed
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = pickerView.superview?.superview?.superview as! GradeSheetCell
        cell.gradeItem.gradeIndex = row
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Global.main.letterGrades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Global.main.letterGrades[row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeSheet.grades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GradeSheetCell", for: indexPath) as! GradeSheetCell
        cell.gradeItem = gradeSheet.getGrade(at: indexPath.row)
        cell.gradePicker.layer.cornerRadius = 10
        cell.creditLabel.text = "0.0"
        cell.rowNumber.text = "\(indexPath.row+1)"
        return cell
    }
    
    var gradeSheet: GradeSheet!
    @IBOutlet weak var unweightedLabel: UILabel!
    @IBOutlet weak var weightedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addSubjectButton: UIButton!
    @IBOutlet weak var topBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        topBar.layer.cornerRadius = 20
        topBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction func addSubjectPressed(_ sender: UIButton) {
        gradeSheet.addGrade()
        tableView.insertRows(at: [IndexPath(row: gradeSheet.grades.count-1, section: 0)], with: .bottom)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

class GradeSheetCell: UITableViewCell {
    @IBOutlet weak var rowNumber: UILabel!
    @IBOutlet weak var backView: ShadowView!
    @IBOutlet weak var gradePicker: UIPickerView!
    @IBOutlet weak var subjectName: UITextField!
    @IBOutlet weak var subjectType: UISegmentedControl!
    @IBOutlet weak var creditStepper: UIStepper!
    @IBOutlet weak var creditLabel: UILabel!
    var gradeItem: GradeItem!
}
