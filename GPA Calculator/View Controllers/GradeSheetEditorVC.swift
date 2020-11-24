//
//  GradeSheetEditorVC.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/20/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class GradeSheetEditorVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell = textField.superview?.superview?.superview as! GradeSheetCell
        cell.gradeItem.className = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }
    
    /// Class name field changed
    @IBAction func textFieldChanged(_ sender: UITextField) {
        let cell = sender.superview?.superview?.superview as! GradeSheetCell
        cell.gradeItem.className = sender.text ?? ""
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
        updateWeightedGPA()
    }
    
    /// Credits stepper changed
    @IBAction func creditStepperChanged(_ sender: UIStepper) {
        let cell = sender.superview?.superview?.superview as! GradeSheetCell
        cell.gradeItem.credits = sender.value
        cell.creditLabel.text = "\(sender.value)"
        updateWeightedGPA()
    }
    
    /// Grade picker changed
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = pickerView.superview?.superview?.superview as! GradeSheetCell
        cell.gradeItem.gradeIndex = row
        updateUnweightedGPA()
        updateWeightedGPA()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Global.main.letterGrades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: Global.main.letterGrades[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeSheet.grades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GradeSheetCell", for: indexPath) as! GradeSheetCell
        cell.gradeItem = gradeSheet.getGrade(at: indexPath.row)
        cell.gradePicker.layer.cornerRadius = 10
        cell.gradePicker.selectRow(cell.gradeItem.gradeIndex, inComponent: 0, animated: false)
        cell.creditStepper.value = cell.gradeItem.credits
        cell.creditLabel.text = "\(cell.gradeItem.credits)"
        cell.subjectName.text = cell.gradeItem.className
        switch cell.gradeItem.classType {
        case .standard: cell.subjectType.selectedSegmentIndex = 0
        case .honors: cell.subjectType.selectedSegmentIndex = 1
        case .advanced: cell.subjectType.selectedSegmentIndex = 2
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedGrade = gradeSheet.removeGrade(index: indexPath.row)
            print("Removed grade:\n\t\(removedGrade)")
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateUnweightedGPA()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        gradeSheet.moveGrade(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    var gradeSheet: GradeSheet!
    var originalGradeSheet: GradeSheet!
    var isCreating = false
    @IBOutlet weak var unweightedLabel: UILabel!
    @IBOutlet weak var weightedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addSubjectButton: UIButton!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var optionsButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalGradeSheet = gradeSheet.copy()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        topBar.layer.cornerRadius = 20
        topBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        optionsButton.primaryAction = nil
        optionsButton.menu = UIMenu(title: "", children: [
            UIAction(title: "Select GPA type", image: UIImage(systemName: "doc.text.magnifyingglass"), identifier: nil, discoverabilityTitle: nil, state: .off, handler: { (action) in
                print("Select GPA type option pressed")
                self.performSegue(withIdentifier: "showCustomGPAPickerVC", sender: nil)
            }),
            UIAction(title: "Debug print", image: UIImage(systemName: "terminal"), identifier: nil, discoverabilityTitle: nil, state: .off, handler: { (action) in
                print("Debug print option pressed")
                print(self.gradeSheet!)
            }),
        ])
        
        updateUnweightedGPA()
        updateWeightedGPA()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUnweightedGPA()
        updateWeightedGPA()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCustomGPAPickerVC" {
            let vc = segue.destination as! CustomGPAPickerVC
            vc.gradeSheet = gradeSheet
        } else if segue.identifier == "showSaveGradeSheetVC" {
            let vc = segue.destination as! SaveGradeSheetVC
            vc.gradeSheet = gradeSheet
            vc.originalGradeSheet = originalGradeSheet
            vc.isCreating = isCreating
        }
    }
    
    @IBAction func addSubjectPressed(_ sender: UIButton) {
        gradeSheet.addGrade()
        tableView.insertRows(at: [IndexPath(row: gradeSheet.grades.count-1, section: 0)], with: .bottom)
        updateUnweightedGPA()
        updateWeightedGPA()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        editButton.title = tableView.isEditing ? "Done" : "Edit"
        editButton.style = tableView.isEditing ? .done : .plain
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showSaveGradeSheetVC", sender: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        showAlert(self, title: "Confirm exit", message: "Are you sure you want to exit? Your changes will be discarded.", actions: [
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
            UIAlertAction(title: "Exit", style: .destructive, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
        ])
    }
    
    func updateUnweightedGPA() {
        unweightedLabel.text = "\(round(gradeSheet.getUnweightedGPA()*10000.0)/10000.0)"
    }
    
    func updateWeightedGPA() {
        weightedLabel.text = "\(round(gradeSheet.getWeightedGPA(scale: Global.main.customGPAs[gradeSheet.customGPAIdx])*10000.0)/10000.0)"
    }
}

class GradeSheetCell: UITableViewCell {
    @IBOutlet weak var backView: ShadowView!
    @IBOutlet weak var gradePicker: UIPickerView!
    @IBOutlet weak var subjectName: UITextField!
    @IBOutlet weak var subjectType: UISegmentedControl!
    @IBOutlet weak var creditStepper: UIStepper!
    @IBOutlet weak var creditLabel: UILabel!
    var gradeItem: GradeItem!
}
