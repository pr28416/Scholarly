//
//  FolderControllerTableViewController.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 2/12/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//

import UIKit

class FolderController: UITableViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return globalStorage.count
    }
    
    var selectedRow = 0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = globalStorage[indexPath.row][0][6]
        let confirmAlert = UIAlertController(title: "Load schedule", message: "Do you want to load \(name)?", preferredStyle: .alert)
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { (action) in
            self.selectedRow = indexPath.row
            //            self.performSegue(withIdentifier: "loadSchedule", sender: nil)
            
            print("Sending folder:", globalStorage[self.selectedRow])
            let vc = self.navigationController?.viewControllers.first as! GPACalcHome
            vc.classInfo = globalStorage[self.selectedRow]
            vc.calculationTable.reloadData()
            print("New file:", vc.classInfo)
            self.navigationController?.popToRootViewController(animated: true)
            vc.calculationTable.reloadData()
        }))
        self.present(confirmAlert, animated: true
            , completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadSchedule" {
            let navVC = segue.destination as? UINavigationController
            
            let tableVC = navVC?.viewControllers.first as! GPACalcHome
            
            tableVC.classInfo = globalStorage[selectedRow]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath) as! folderCell
        
        cell.scheduleName.text = "\(globalStorage[indexPath.row][0][6])"
        cell.gpaPreview.text = "\(globalStorage[indexPath.row][0][9])"
        
        let date = globalStorage[indexPath.row][0][8]
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date as! Date)
        let month = calendar.component(.month, from: date as! Date)
        let year = calendar.component(.year, from: date as! Date)
        cell.dateCreated.text = "Created: \(month)/\(day)/\(year)"
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            globalStorage.remove(at: indexPath.row)
            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { /*tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.none);*/tableView.reloadData() })
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
}
