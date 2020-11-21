//
//  CustomGPAPickerVC.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/21/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class CustomGPAPickerVC: UITableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Global.main.customGPAs.count <= 2 ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Default", "Custom"][section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : Global.main.customGPAs.count - 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customGPAPickerCell", for: indexPath)
        let list = Global.main.customGPAs
        cell.textLabel?.text = "\(list[indexPath.row + (indexPath.section == 0 ? 0 : 2)].title)"
        return cell
    }
    
    var previousViewController: GradeSheetEditorVC!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idx = indexPath.row + (indexPath.section == 0 ? 0 : 2)
        let selectedCustomGPA = Global.main.customGPAs[idx]
        self.previousViewController.selectedCustomGPA = selectedCustomGPA
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
