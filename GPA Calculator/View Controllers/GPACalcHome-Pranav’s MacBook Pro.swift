//
//  GPACalcHome.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 2/9/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
/*
 case 0:
 classInfo[(indexPath?.row)!][2] = 4.33
 case 1:
 classInfo[(indexPath?.row)!][2] = C4.00
 case 2:
 classInfo[(indexPath?.row)!][2] = 3.67
 case 3:
 classInfo[(indexPath?.row)!][2] = 3.33
 case 4:
 classInfo[(indexPath?.row)!][2] = 3.00
 case 5:
 classInfo[(indexPath?.row)!][2] = 2.67
 case 6:
 classInfo[(indexPath?.row)!][2] = 2.33
 case 7:
 classInfo[(indexPath?.row)!][2] = 2.00
 case 8:
 classInfo[(indexPath?.row)!][2] = 1.67
 case 9:
 classInfo[(indexPath?.row)!][2] = 1.33
 case 10:
 classInfo[(indexPath?.row)!][2] = 1.00
 case 11:
 classInfo[(indexPath?.row)!][2] = 0.67
 case 12:
 classInfo[(indexPath?.row)!][2] = 0.00
 default:
 classInfo[(indexPath?.row)!][2] = 4.33
 }
 */

import UIKit
import PCLBlurEffectAlert

var globalStorage: [[[Any]]] = []

class GPACalcHome: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var classInfo = [
        ["", 0, 4.33, 0.0, "College Prep", 0, "Unnamed", "", 0] // [class name, grade index, weight for grade, credits, type, type index, ClassInfo Schedule name, schedule ID (UUID), timestamp]
    ]
    
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Save Schedule", message: "Enter a name to save this schedule.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Schedule name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            
            if !self.classInfo.isEmpty {
                for i in 0...self.classInfo.count-1 {
                    if let text = alert.textFields?[0].text {
                        if text.isEmpty {
                            self.classInfo[i][6] = "Unnamed"
                        } else {
                            self.classInfo[i][6] = text
                        }
                    }
                }
                
                if !globalStorage.isEmpty {
                    print("Global storage not empty")
                    for selectionIndex in 0...globalStorage.count-1 {
                        
                        if globalStorage[selectionIndex][0][7] as! String == self.classInfo[0][7] as! String {
                            
                            print("Found correspondence - file exists")
                            
                            let note = UIAlertController(title: "Overwrite schedule?", message: "This schedule already exists. Would you like to overwrite the existing schedule or save as a new schedule?", preferredStyle: .alert)
                            
                            
                            note.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
                                
                                print("Found correspondence - file exists - Overwriting schedule")
                                
                                globalStorage[selectionIndex] = self.classInfo
                                let confirmation = UIAlertController(title: "Successfully saved", message: "Your existing schedule has been successfully overwritten.", preferredStyle: .alert)
                                confirmation.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                let userDefaults = UserDefaults.standard
                                userDefaults.self.set(globalStorage, forKey: "globalStorage")
                                userDefaults.self.set(globalStorage, forKey: "customGPAList")
                                self.present(confirmation, animated: true, completion: nil)
                                
                                
                            }))
                            
                            
                            note.addAction(UIAlertAction(title: "Save as new", style: .default, handler: { (action) in
                                let uuid = UUID().uuidString
                                let timeStamp = NSDate()
                                
                                print("Found correspondence - file exists - Saving as new")
                                
                                for item in 0...self.classInfo.count-1 {
                                    self.classInfo[item][7] = "\(uuid)"
                                    self.classInfo[item][8] = timeStamp
                                }
                                
                                globalStorage.insert(self.classInfo, at: 0)
                                
                                let confirmation = UIAlertController(title: "Successfully saved", message: "You have successfully added a new schedule.", preferredStyle: .alert)
                                
                                confirmation.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                
                                let userDefaults = UserDefaults.standard
                                userDefaults.self.set(globalStorage, forKey: "globalStorage")
                                userDefaults.self.set(globalStorage, forKey: "customGPAList")
                                
                                self.present(confirmation, animated: true, completion: nil)
                                
                            }))
                            
                            note.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            
                            print("Found correspondence - file exists - Canceling request")
                            
                            let userDefaults = UserDefaults.standard
                            userDefaults.self.set(globalStorage, forKey: "globalStorage")
                            userDefaults.self.set(globalStorage, forKey: "customGPAList")
                            
                            self.present(note, animated: true, completion: nil)
                            print("Commencing break")
                            break
                        } else {
                            
                            print("Did not find correspondence - file doesn't exist")
                            
                            let uuid = UUID().uuidString
                            let timeStamp = NSDate()
                            
                            for item in 0...self.classInfo.count-1 {
                                self.classInfo[item][7] = "\(uuid)"
                                self.classInfo[item][8] = timeStamp
                            }
                            
                            globalStorage.insert(self.classInfo, at: 0)
                            
                            let confirmation = UIAlertController(title: "Successfully saved", message: "You have successfully added a new schedule.", preferredStyle: .alert)
                            
                            confirmation.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            let userDefaults = UserDefaults.standard
                            userDefaults.self.set(globalStorage, forKey: "globalStorage")
                            userDefaults.self.set(globalStorage, forKey: "customGPAList")
                            
                            print("Did not find correspondence - file doesn't exist - saving and adding new schedule")
                            
                            self.present(confirmation, animated: true, completion: nil)
                            print("Commencing break")
                            break
                        }
                        
                    }
                } else {
                    
                    let uuid = UUID().uuidString
                    let timeStamp = NSDate()
                    
                    for item in 0...self.classInfo.count-1 {
                        self.classInfo[item][7] = "\(uuid)"
                        self.classInfo[item][8] = timeStamp
                    }
                    
                    globalStorage.insert(self.classInfo, at: 0)
                    let confirmation = UIAlertController(title: "Successfully saved", message: "You have successfully added a new schedule.", preferredStyle: .alert)
                    confirmation.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(confirmation, animated: true, completion: nil)
                    
                }
            } else {
                print("Empty schedule")
                let errorAlert = UIAlertController(title: "Empty schedule", message: "You need to put in some classes before you save!", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var weightedText: UILabel!
    var GPA = 0.00
    var possibleGrades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"] // mod 13
    
    // Weighted Honors A = 4.33
    
    var cpGrades433: [Double] = [4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 1.33, 1.00, 0.67, 0.00]
    var honorsGrades433: [Double] = [4.67, 4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 1.33, 1.00, 0.00]
    var ap_ibGrades433: [Double] = [5.00, 4.67, 4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 1.33, 0.00]
    
    // Weighted Honors A = 4.5
    
    var cpGrades45: [Double] = [4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 1.33, 1.00, 0.67, 0.00]
    var honorsGrades45: [Double] = [4.83, 4.50, 4.17, 3.83, 3.50, 3.17, 2.83, 2.50, 2.17, 1.83, 1.50, 1.17, 0.00]
    var ap_ibGrades45: [Double] = [5.33, 5.00, 4.67, 4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 0.00]
    //-----------
    
    
    @IBOutlet var toolbar: UIToolbar!
    var list = ["College Prep", "Honors", "AP", "IB"]
    var gpaTypes = ["Weighted GPA: Honors A = 4.33", "Weighted GPA: Honors A = 4.50"]
    var currentGPAtype = 1
    
    @IBOutlet var cumulativeGPA: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        currentGPAtype = 1
        calculateUnweightedGPA()
        calculateWeightedGPA()
        navigationItem.leftBarButtonItem = editButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(GPACalcHome.keyboardWillShow), name: UIApplication.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GPACalcHome.keyboardWillHide), name: UIApplication.keyboardWillHideNotification, object: nil)
        
        
        toolbar.layer.masksToBounds = true
//        toolbar.clipsToBounds = true
        toolbar.layer.cornerRadius = 20
        toolbar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    
    
    /*  ["", 0, 4.33, 0.0, "College Prep", 0]
     [class name, grade index, weight for grade, credits, type, type index]
     */
    func calculateUnweightedGPA() {
        var sum: Double = 0.0
        var creditSum: Double = 0.0
        if !classInfo.isEmpty {
            for i in 0...classInfo.count-1 {
                sum += (classInfo[i][2] as! Double)*(classInfo[i][3] as! Double)
                creditSum += classInfo[i][3] as! Double
            }
            if creditSum == 0 {
                
                cumulativeGPA.text = "Unweighted: N/A"
            } else {
                var value: Double = Double(round(1000*(sum/Double(creditSum)))/1000)
                value = Double(round(10000*value)/10000)
                
                cumulativeGPA.text = "Unweighted: \(value)"
            }
        } else {
            cumulativeGPA.text = "Unweighted: N/A"
        }
        
    }
    
    // [class name, grade index, weight for grade, credits, type, type index, ClassInfo Schedule name, schedule ID (UUID), timestamp]
    
    func calculateWeightedGPA() {
        if currentGPAtype == 1 {
//            var classTypeCount = [0, 0, 0, 0] // [College Prep, Honors, AP, IB]
//            var sum: Double = 0.0
//            var creditSum: Double = 0.0
//            if !classInfo.isEmpty {
//                for type in 0...classInfo.count-1 {
//                    switch classInfo[type][5] as! Int {
//                    case 0:
//                        classTypeCount[0] += 1
//                    case 1:
//                        classTypeCount[1] += 1
//                    case 2:
//                        classTypeCount[2] += 1
//                    case 3:
//                        classTypeCount[3] += 1
//                    default:
//                        classTypeCount[0] += 1
//                    }
//                }
//                for i in 0...classInfo.count-1 {
//                    sum += (classInfo[i][2] as! Double)*(classInfo[i][3] as! Double)
//                    creditSum += classInfo[i][3] as! Double
//                }
//                if creditSum == 0 {
//
//                    weightedText.text = "Weighted: N/A"
//                } else {
//
//
//                    let weightedSum: Double = sum + (0.5 * Double(classTypeCount[1])) + Double(classTypeCount[2] + classTypeCount[3])
//                    var value: Double = weightedSum/Double(classInfo.count)
//                    value = Double(round(10000*value)/10000)
//
//
//                    weightedText.text = "Weighted: \(value)"
//
//                }
            
//            } else {
//                weightedText.text = "Weighted: N/A"
//            }
            
            
            var sum: Double = 0.0
            var creditSum: Double = 0.0
            if !classInfo.isEmpty {
                for row in 0...classInfo.count-1 {
                    switch classInfo[row][4] as! String {
                    case "College Prep":
                        sum += cpGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "Honors":
                        sum += honorsGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "AP":
                        sum += ap_ibGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "IB":
                        sum += ap_ibGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    default:
                        sum += cpGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    }
                    creditSum += classInfo[row][3] as! Double
                }
                
                if creditSum == 0 {
                    
                    weightedText.text = "Weighted: N/A"
                } else {
                    var value: Double = Double(round(1000*(sum/Double(creditSum)))/1000)
                    value = Double(round(10000*value)/10000)
                    
                    weightedText.text = "Weighted: \(value)"
                }
            } else {
                weightedText.text = "Weighted: N/A"
            }
            
            
            
        } else if currentGPAtype == 0 {
            var sum: Double = 0.0
            var creditSum: Double = 0.0
            if !classInfo.isEmpty {
                for row in 0...classInfo.count-1 {
                    switch classInfo[row][4] as! String {
                    case "College Prep":
                        sum += cpGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "Honors":
                        sum += honorsGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "AP":
                        sum += ap_ibGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "IB":
                        sum += ap_ibGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    default:
                        sum += cpGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    }
                    creditSum += classInfo[row][3] as! Double
                }

                if creditSum == 0 {
                    
                    weightedText.text = "Weighted: N/A"
                } else {
                    var value: Double = Double(round(1000*(sum/Double(creditSum)))/1000)
                    value = Double(round(10000*value)/10000)
                    
                    weightedText.text = "Weighted: \(value)"
                }
            } else {
                weightedText.text = "Weighted: N/A"
            }
        }
    }
/*  ["", 0, 4.33, 0.0, "College Prep", 0]
    [class name, grade index, weight for grade, credits, type, type index]
*/
    
    
    @IBAction func changeGPAType(_ sender: UIBarButtonItem) {
        
        let alert = PCLBlurEffectAlertController(title: "Select GPA Type", message: nil, effect: UIBlurEffect(style: .dark), style: .alertVertical)
        
        let firstAction = PCLBlurEffectAlertAction(title: gpaTypes[0], style: .default, handler: { (action) in
            self.currentGPAtype = 0
            self.calculateUnweightedGPA()
            self.calculateWeightedGPA()
            print(self.currentGPAtype)
        })
        let secondAction = PCLBlurEffectAlertAction(title: gpaTypes[1], style: .default) { (action) in
            self.currentGPAtype = 1
            self.calculateUnweightedGPA()
            self.calculateWeightedGPA()
            print(self.currentGPAtype)
        }
        let cancelAction = PCLBlurEffectAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.configure(titleColor: .white)
        let Red: CGFloat = 72
        let Green: CGFloat = 166
        let Blue: CGFloat = 225
        let color = UIColor.white
        alert.configure(backgroundColor: UIColor(red: Red/255, green: Green/255, blue: Blue/255, alpha: 0.6))
        alert.configure(buttonBackgroundColor: UIColor(red: Red/255, green: Green/255, blue: Blue/255, alpha: 0.6))
        alert.configure(buttonFont: nil, buttonTextColor: [PCLBlurEffectAlert.ActionStyle.default : color], buttonDisableTextColor: nil)
        alert.configure(buttonFont: nil, buttonTextColor: [PCLBlurEffectAlert.ActionStyle.cancel: color], buttonDisableTextColor: nil)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classInfo.count
    }
    
    @IBAction func courseEditingEnded(_ sender: UITextField) {
        let cell = sender.superview?.superview?.superview as! classCell
        let indexPath = calculationTable.indexPath(for: cell)
        if let className = cell.classNameField.text {
            if let path = indexPath?.row {
                print("Path:",path)
                classInfo[path][0] = className
            }
            
        }
        print("\nModified table")
        if !classInfo.isEmpty {
        for i in 0...classInfo.count-1 {
            print("\(i): \(classInfo[i])")
        }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! classCell
        
        cell.classType.text = list[classInfo[indexPath.row][5] as! Int]
        cell.creditControl.value = classInfo[indexPath.row][3] as! Double
        cell.creditNum.text = "\(classInfo[indexPath.row][3])"
        cell.creditNum.text = "\(cell.creditControl.value)"
        cell.blackOverlay.layer.cornerRadius = 10
        cell.classNameField.delegate = self as? UITextFieldDelegate
        cell.numberRow.text = "\(indexPath.row + 1)"
        cell.numberRow.layer.cornerRadius = 12.0
        cell.pickerView.layer.cornerRadius = cell.pickerView.frame.width/2
        cell.pickerView.selectRow(classInfo[indexPath.row][1] as! Int, inComponent: 0, animated: false)
        cell.creditControl.layer.cornerRadius = cell.creditControl.frame.height / 2
        cell.leftButton.layer.cornerRadius = 3
        cell.rightButton.layer.cornerRadius = 3
        cell.leftButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        cell.rightButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        cell.creditControl.layer.borderColor = UIColor.white.cgColor
        cell.creditControl.layer.borderWidth = 1
        cell.creditControl.layer.masksToBounds = true
        
        
        for i in [1, 2] {
            cell.pickerView.subviews[i].isHidden = true
        }
        
        if let text = classInfo[indexPath.row][0] as? String {
            cell.classNameField.text = text
        }
        
        
        return cell
    }
    //------------------
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            calculationTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 80, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            calculationTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func newSchedule(_ sender: UIBarButtonItem) {
        classInfo.removeAll()
        calculationTable.reloadData()
        calculateUnweightedGPA()
        calculateWeightedGPA()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        calculationTable.reloadData()
    }
    
    //------------------
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("\nDeleted item from table: \(classInfo[indexPath.row])")
            classInfo.remove(at: indexPath.row)
            print("\n")
            
            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { /*tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.none);*/tableView.reloadData() })
            if !classInfo.isEmpty {
                for i in 0...classInfo.count-1 {
                    print("\(i): \(classInfo[i])")
                }
                print("\n")
            }
            calculateUnweightedGPA()
            calculateWeightedGPA()
        }
    }
    
    @IBOutlet var calculationTable: UITableView!
    
    // UIPICKERVIEW ----------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return possibleGrades.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            
            return possibleGrades[row]
            
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = possibleGrades[row]
        pickerLabel.font = UIFont(name: "Avenir Heavy", size: 40)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    /*  ["", 0, 4.33, 0.0, "College Prep", 0]
     [class name, grade index, weight for grade, credits, type, type index]
     */
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let cell = pickerView.superview?.superview?.superview as! classCell
            let indexPath = calculationTable.indexPath(for: cell)
            
            classInfo[(indexPath?.row)!][1] = row
            
            switch row {
            case 0:
                classInfo[(indexPath?.row)!][2] = 4.33
            case 1:
                classInfo[(indexPath?.row)!][2] = 4.00
            case 2:
                classInfo[(indexPath?.row)!][2] = 3.67
            case 3:
                classInfo[(indexPath?.row)!][2] = 3.33
            case 4:
                classInfo[(indexPath?.row)!][2] = 3.00
            case 5:
                classInfo[(indexPath?.row)!][2] = 2.67
            case 6:
                classInfo[(indexPath?.row)!][2] = 2.33
            case 7:
                classInfo[(indexPath?.row)!][2] = 2.00
            case 8:
                classInfo[(indexPath?.row)!][2] = 1.67
            case 9:
                classInfo[(indexPath?.row)!][2] = 1.33
            case 10:
                classInfo[(indexPath?.row)!][2] = 1.00
            case 11:
                classInfo[(indexPath?.row)!][2] = 0.67
            case 12:
                classInfo[(indexPath?.row)!][2] = 0.00
            default:
                classInfo[(indexPath?.row)!][2] = 4.33
            }
            
            calculateUnweightedGPA()
            calculateWeightedGPA()
            
            print("\nModified grade in table: \(classInfo[(indexPath?.row)!])")
            print("\n")
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 1 {
            let titleData = possibleGrades[row]
            let attributedString = NSAttributedString(string: titleData, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font:UIFont(name: "Avenir", size: 40.0)!
                ])
            return attributedString
        } else if pickerView.tag == 2 {
            let titleData = possibleGrades[row]
            let attributedString = NSAttributedString(string: titleData, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white
                ])
            return attributedString
        }
        return nil
    }
    
    //-----------------------
    
    
    @IBAction func addRow(_ sender: UIBarButtonItem) {
        
        classInfo.append(["", 0, 4.33, 0.0, "College Prep", 0, "Unnamed", "", 0])
        calculationTable.reloadData()
        calculateUnweightedGPA()
        calculateWeightedGPA()
        
        if !classInfo.isEmpty {
        print("\nAdded new item")
        for i in 0...classInfo.count-1 {
            print("\(i): \(classInfo[i])")
        }
        print("\n")
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        if editing {
            calculationTable.setEditing(true, animated: true)
        } else {
            calculationTable.setEditing(false, animated: true)
        }

    }
    @IBAction func capture(_ sender: UIBarButtonItem) {
        if !classInfo.isEmpty{
        print("\nCapturing")
        for i in 0...classInfo.count-1 {
            print("\(i): \(classInfo[i])")
        }
        print("\n")
        }
    }
    
    @IBAction func creditsChanged(_ sender: UIStepper) {
        let cell = sender.superview?.superview?.superview as! classCell
        let indexPath = calculationTable.indexPath(for: cell)
        classInfo[(indexPath?.row)!][3] = cell.creditControl.value
        cell.creditNum.text = "\(cell.creditControl.value)"
        calculateUnweightedGPA()
        calculateWeightedGPA()
    }
    
    @IBAction func rightCourse(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview?.superview as! classCell
        let indexPath = calculationTable.indexPath(for: cell)
        
        if classInfo[(indexPath?.row)!][5] as! Int == cell.typeList.count-1 {
            cell.classType.text = cell.typeList[0]
            classInfo[(indexPath?.row)!][4] = cell.typeList[0]
            classInfo[(indexPath?.row)!][5] = 0
        } else {
            cell.classType.text = cell.typeList[classInfo[(indexPath?.row)!][5] as! Int + 1]
            classInfo[(indexPath?.row)!][5] = classInfo[(indexPath?.row)!][5] as! Int + 1
            classInfo[(indexPath?.row)!][4] = cell.typeList[classInfo[(indexPath?.row)!][5] as! Int]
            
        }
        calculateUnweightedGPA()
        calculateWeightedGPA()
    }
    @IBAction func leftCourse(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview?.superview as! classCell
        let indexPath = calculationTable.indexPath(for: cell)
        
        if classInfo[(indexPath?.row)!][5] as! Int == 0 {
            cell.classType.text = cell.typeList[cell.typeList.count-1]
            classInfo[(indexPath?.row)!][4] = cell.typeList[cell.typeList.count-1]
            classInfo[(indexPath?.row)!][5] = cell.typeList.count-1

        } else {
            cell.classType.text = cell.typeList[classInfo[(indexPath?.row)!][5] as! Int - 1]
            classInfo[(indexPath?.row)!][5] = classInfo[(indexPath?.row)!][5] as! Int - 1
            classInfo[(indexPath?.row)!][4] = cell.typeList[classInfo[(indexPath?.row)!][5] as! Int]
        }
        calculateUnweightedGPA()
        calculateWeightedGPA()
    }
    
}
