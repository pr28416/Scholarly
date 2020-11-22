//
//  MainMenuVC.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/19/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func debugReload(_ sender: Any) {
        reload()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection", Global.main.gradeSheets.count)
        return Global.main.gradeSheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentGradeSheetCell", for: indexPath) as! RecentGradeSheetCell
        if Global.main.gradeSheets[indexPath.row].title.count != 0 {
            cell.title.text = Global.main.gradeSheets[indexPath.row].title
        } else {
            cell.title.text = "Unnamed"
        }
        cell.weight.text = Global.main.customGPAs[Global.main.gradeSheets[indexPath.row].customGPAIdx].title
        let ts = Global.main.gradeSheets[indexPath.row].timestamp
        cell.dateModified.text = "\(Date.stringFromDate(ts, format: "h:mm a")) on \(Date.stringFromDate(ts, format: "MMM d, YYYY"))"
        cell.gpa.text = "\(Global.main.gradeSheets[indexPath.row].getWeightedGPA(scale: Global.main.customGPAs[Global.main.gradeSheets[indexPath.row].customGPAIdx]))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editGradeSheetSegue", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Global.main.gradeSheets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editGradeSheetSegue", "createNewGradeSheetSegue":
            let vc = (segue.destination as! UINavigationController).viewControllers[0] as! GradeSheetEditorVC
            if segue.identifier == "editGradeSheetSegue" {
                vc.gradeSheet = Global.main.gradeSheets[sender as! Int]
                vc.isCreating = false
            } else {
                vc.gradeSheet = GradeSheet()
                vc.gradeSheet.addGrade()
                vc.isCreating = true
            }
        default: break
        }
    }
    
    @IBAction func pressedCreateNewGradeSheet(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createNewGradeSheetSegue", sender: nil)
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.setTitle(tableView.isEditing ? "Done" : "Edit", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewGradeSheet.backgroundColor = UIColor.atlassian.primaryBlue
        cumulativeCalculator.backgroundColor = UIColor.atlassian.primaryGreen
        gpaWeightingCalculator.backgroundColor = UIColor.atlassian.primaryRed
        testScoreCalculator.backgroundColor = UIColor.atlassian.primaryYellow
        
        Global.main.gradeSheets.sort { (g1, g2) -> Bool in
            return g1.timestamp > g2.timestamp
        }
        
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .mainMenuReloadTable, object: nil)
    }
    
    @objc func reload() {
        tableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.tableViewHeight.constant = self.tableView.contentSize.height
        } completion: { (_) in
            self.view.layoutIfNeeded()
            print(self.tableView.contentSize.height)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createNewGradeSheet: ShadowView!
    @IBOutlet weak var cumulativeCalculator: ShadowView!
    @IBOutlet weak var gpaWeightingCalculator: ShadowView!
    @IBOutlet weak var testScoreCalculator: ShadowView!
}

class RecentGradeSheetCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var dateModified: UILabel!
    @IBOutlet weak var gpa: UILabel!
}
