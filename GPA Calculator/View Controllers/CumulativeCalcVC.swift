//
//  CumulativeCalcVC.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/25/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class CumulativeCalcVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.main.gradeSheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainGradeSheetCell", for: indexPath) as! MainGradeSheetCell
        let gradeSheet = Global.main.gradeSheets[indexPath.row]
        cell.title.text = gradeSheet.title
        cell.weight.isHidden = true
        cell.dateModified.text = "\(Date.stringFromDate(gradeSheet.timestamp, format: "h:mm a")) on \(Date.stringFromDate(gradeSheet.timestamp, format: "MMM d, YYYY"))"
        cell.weightedTitle.text = "WEIGHTED"
        cell.gpa.text = "\(gradeSheet.getWeightedGPA(scale: customGPA))"
        cell.gradeSheet = gradeSheet
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recalculate()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        recalculate()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Global.main.customGPAs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Global.main.customGPAs[row].title
    }
    
    @IBOutlet weak var unweightedScoreLabel: UILabel!
    @IBOutlet weak var weightedScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scaleSelect: UITextField!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var modeControl: UISegmentedControl!
    
    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        recalculate()
    }
    
    var pickerView: UIPickerView!
    var customGPA: CustomGPA!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.sizeToFit()
        pickerView.selectRow(Global.main.defaultCustomGPAIdx, inComponent: 0, animated: false)
        
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        ]
        toolbar.sizeToFit()
        scaleSelect.inputView = pickerView
        scaleSelect.inputAccessoryView = toolbar
        
        tableView.setEditing(true, animated: false)
        
        tableView.reloadData()
        self.view.layoutIfNeeded()
        self.tableViewHeight.constant = self.tableView.contentSize.height
        
        print("table height:", tableViewHeight.constant)
        
        recalculate()
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
        customGPA = Global.main.customGPAs[pickerView.selectedRow(inComponent: 0)]
        tableView.reloadData()
        recalculate()
    }
    
    func recalculate() {
        scaleSelect.text = customGPA.title
        
        var totalUnweighted: Double = 0
        var totalWeighted: Double = 0
        
        if modeControl.selectedSegmentIndex == 0 {
            if let indexPaths = tableView.indexPathsForSelectedRows {
                var numberOfCredits = 0.0
                
                for i in indexPaths {
                    let g = tableView.cellForRow(at: i) as! MainGradeSheetCell
                    totalUnweighted += g.gradeSheet.getUnweightedGPA() * Double(g.gradeSheet.grades.count)
                    let credits = g.gradeSheet.totalCredits
                    totalWeighted += g.gradeSheet.getWeightedGPA() * credits
                    numberOfCredits += credits
                }
                
                totalUnweighted /= numberOfCredits
                totalWeighted /= numberOfCredits
            }
        } else {
            if let indexPaths = tableView.indexPathsForSelectedRows {
                for i in indexPaths {
                    let g = tableView.cellForRow(at: i) as! MainGradeSheetCell
                    totalUnweighted += g.gradeSheet.getUnweightedGPA()
                }
                totalUnweighted /= Double(indexPaths.count)
                
                for i in indexPaths {
                    let g = tableView.cellForRow(at: i) as! MainGradeSheetCell
                    totalWeighted += g.gradeSheet.getWeightedGPA(scale: customGPA)
                }
                totalWeighted /= Double(indexPaths.count)
            }
        }
        
        unweightedScoreLabel.text = String(format: "%.3f", totalUnweighted)
        weightedScoreLabel.text = String(format: "%.3f", totalWeighted)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
