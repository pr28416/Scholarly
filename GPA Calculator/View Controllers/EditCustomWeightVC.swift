//
//  EditCustomWeightVC.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/24/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class EditCustomWeightVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag < 3 {
            var num = 0.00
            if let text = textField.text, let number = Double(text), number >= 0.0 {
                num = number
            } else {
                num = 0.00
                textField.text = "0.0"
            }
                
            switch textField.tag {
            case 0: customGPA.chart[Global.main.gradeLetter(for: (textField.superview?.superview?.superview as! CustomWeightCell).rowNumber)]?.standard = num
            case 1: customGPA.chart[Global.main.gradeLetter(for: (textField.superview?.superview?.superview as! CustomWeightCell).rowNumber)]?.honors = num
            case 2: customGPA.chart[Global.main.gradeLetter(for: (textField.superview?.superview?.superview as! CustomWeightCell).rowNumber)]?.advanced = num
            default: break
            }
            return true
            
        }
        return true
    }
    
    @IBAction func standardChanged(_ sender: UITextField) {
        var num = 0.00
        if let text = sender.text, let number = Double(text), number >= 0.0 {
            num = number
        } else {
            sender.text = "0.0"
        }
        customGPA.chart[Global.main.gradeLetter(for: (sender.superview?.superview?.superview as! CustomWeightCell).rowNumber)]?.standard = num
    }
    
    @IBAction func honorsChanged(_ sender: UITextField) {
        var num = 0.00
        if let text = sender.text, let number = Double(text), number >= 0.0 {
            num = number
        } else {
            sender.text = "0.0"
        }
        customGPA.chart[Global.main.gradeLetter(for: (sender.superview?.superview?.superview as! CustomWeightCell).rowNumber)]?.honors = num
    }
    
    @IBAction func advancedChanged(_ sender: UITextField) {
        var num = 0.00
        if let text = sender.text, let number = Double(text), number >= 0.0 {
            num = number
        } else {
            sender.text = "0.0"
        }
        customGPA.chart[Global.main.gradeLetter(for: (sender.superview?.superview?.superview as! CustomWeightCell).rowNumber)]?.advanced = num
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customGPA.chart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomWeightCell", for: indexPath) as! CustomWeightCell
        cell.grade.text = Global.main.gradeLetter(for: indexPath.row)
        let weights = customGPA.getWeights(letter: Global.main.gradeLetter(for: indexPath.row))
        cell.standardWeight.text = "\(weights.standard)"
        cell.honorsWeight.text = "\(weights.honors)"
        cell.advancedWeight.text = "\(weights.advanced)"
        cell.rowNumber = indexPath.row
        
        cell.standardWeight.isUserInteractionEnabled = !isPreviewing
        cell.honorsWeight.isUserInteractionEnabled = !isPreviewing
        cell.advancedWeight.isUserInteractionEnabled = !isPreviewing
        
        return cell
    }
    
    var isCreating = false
    var isPreviewing = false
    var customGPA: CustomGPA!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var sheetTitleField: UITextField!
    
    @IBAction func sheetTitleChanged(_ sender: UITextField) {
        customGPA.title = sender.text ?? ""
    }
    
    @objc func dismissKeyboard() {
        self.view.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        topBar.layer.cornerRadius = 15
        topBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.isModalInPresentation = true
        
        sheetTitleField.text = customGPA.title
        if isPreviewing {
            self.title = "Previewing Weight Sheet"
            sheetTitleField.isUserInteractionEnabled = false
        } else {
            if isCreating {
                self.title = "New Weight Sheet"
            } else {
                self.title = "Edit Weight Sheet"
            }
            sheetTitleField.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func close(_ sender: Any) {
        if isPreviewing {
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(self, title: "Confirm exit", message: "Are you sure you want to exit? Your changes will be discarded.", actions: [
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
                UIAlertAction(title: "Exit", style: .destructive, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
            ])
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        guard !isPreviewing else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        guard !customGPA.title.isEmpty else {showAlert(self, title: "Invalid title", message: "Please provide a title for your custom GPA weight sheet.", actions: [UIAlertAction(title: "Go back", style: .cancel, handler: nil)]); return}
        if isCreating {
            Global.main.customGPAs.append(customGPA)
        }
        Global.main.saveData()
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .customGPASheetsReloadTable, object: nil)
        }
    }
}

class CustomWeightCell: UITableViewCell {
    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var standardWeight: UITextField!
    @IBOutlet weak var honorsWeight: UITextField!
    @IBOutlet weak var advancedWeight: UITextField!
    var rowNumber: Int!
}
