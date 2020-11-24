//
//  WeightEditorVCViewController.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/24/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class WeightEditorVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Global.main.customGPAs.count > 2 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Default", "Custom"][section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : Global.main.customGPAs.count-2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightEditorCell", for: indexPath)
        cell.textLabel?.text = "\(Global.main.customGPAs[indexPath.row + (indexPath.section == 0 ? 0 : 2)].title)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showEditCustomWeightVC", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                showAlert(self, title: "Cannot delete", message: "You cannot delete the default GPA weight scales.", actions: [UIAlertAction(title: "Cancel", style: .cancel, handler: nil)])
            } else {
                Global.main.customGPAs.remove(at: indexPath.row+2)
                Global.main.saveData()
                if Global.main.customGPAs.count == 2 {
                    tableView.deleteSections([1], with: .automatic)
                } else {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditCustomWeightVC" {
            let vc = (segue.destination as! UINavigationController).viewControllers[0] as! EditCustomWeightVC
            let indexPath = sender as! IndexPath
            vc.isCreating = false
            if indexPath.section == 0 {
                vc.isPreviewing = true
                vc.customGPA = Global.main.customGPAs[indexPath.row]
            } else {
                vc.customGPA = Global.main.customGPAs[indexPath.row+2]
                vc.isPreviewing = false
            }
        } else if segue.identifier == "showNewCustomWeightVC" {
            let vc = (segue.destination as! UINavigationController).viewControllers[0] as! EditCustomWeightVC
            vc.customGPA = CustomGPA()
            vc.isCreating = true
            vc.isPreviewing = false
        }
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"
        sender.style = tableView.isEditing ? .done : .plain
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .customGPASheetsReloadTable, object: nil)
    }
    
    @objc func reload() {
        tableView.reloadData()
    }

}
