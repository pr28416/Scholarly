//
//  SaveGradeSheetVC.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/22/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class SaveGradeSheetVC: UITableViewController, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func saveClicked(_ sender: UIButton) {
        guard let name = sheetName.text, name.count != 0 else {
            showAlert(self, title: "Invalid sheet title", message: "Please provide a valid title for your grade sheet.", actions: [UIAlertAction(title: "Go back", style: .cancel, handler: nil)])
            return
        }
        
        gradeSheet.title = name
        if isCreating {
            Global.main.gradeSheets.append(gradeSheet)
        }
        if gpaScaleToggle.isOn {
            gradeSheet.customGPAIdx = Global.main.defaultCustomGPAIdx
        }
        gradeSheet.timestamp = Date()
        Global.main.gradeSheets.sort { (g1, g2) -> Bool in
            g1.timestamp > g2.timestamp
        }
        Global.main.saveData()
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .mainMenuReloadTable, object: nil)
        }
    }
    
    @IBAction func saveAsNewClicked(_ sender: UIButton) {
        guard let name = sheetName.text, name.count != 0 else {
            showAlert(self, title: "Invalid sheet title", message: "Please provide a valid title for your grade sheet.", actions: [UIAlertAction(title: "Go back", style: .cancel, handler: nil)])
            return
        }
        
        gradeSheet.title = name
        gradeSheet.timestamp = Date()
        if gpaScaleToggle.isOn {
            gradeSheet.customGPAIdx = Global.main.defaultCustomGPAIdx
        }
        Global.main.gradeSheets.append(originalGradeSheet)
        Global.main.gradeSheets.sort { (g1, g2) -> Bool in
            g1.timestamp > g2.timestamp
        }
        Global.main.saveData()
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .mainMenuReloadTable, object: nil)
        }
    }
    
    @IBOutlet weak var sheetName: UITextField!
    var isCreating = false
    var gradeSheet: GradeSheet!
    var originalGradeSheet: GradeSheet!
    @IBOutlet weak var saveNewSheetCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveNewSheetCell.isHidden = isCreating
        sheetName.text = gradeSheet.title
    }
    
    @IBOutlet weak var gpaScaleToggle: UISwitch!
    @IBAction func gpaScaleSwitch(_ sender: UISwitch) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            if gpaScaleToggle.isOn {
                return "This sheet will use the default GPA scale called \"\(Global.main.defaultGPA().title)\""
            } else {
                return "This sheet will use the custom GPA scale you selected while editing this sheet called \"\(Global.main.customGPAs[gradeSheet.customGPAIdx].title)\". If you did not change this option while editing this sheet, it will be the same as the default GPA scale."
            }
        }
        return nil
    }
    
}
