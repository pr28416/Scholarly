//
//  MainMenuVC.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/19/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // TODO: Update tableView numberOfRowsInSection return value
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // TODO: Update tableView cellForRowAt return value
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "RecentGradeSheetCell", for: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewGradeSheetSegue" {
            let vc = (segue.destination as! UINavigationController).viewControllers[0] as! GradeSheetEditorVC
            vc.gradeSheet = GradeSheet()
            vc.gradeSheet.addGrade()
            vc.selectedCustomGPA = Global.main.customGPAs[0]
        }
    }
    
    @IBAction func pressedCreateNewGradeSheet(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createNewGradeSheetSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewGradeSheet.backgroundColor = UIColor.atlassian.primaryBlue
        cumulativeCalculator.backgroundColor = UIColor.atlassian.primaryGreen
        gpaWeightingCalculator.backgroundColor = UIColor.atlassian.primaryRed
        testScoreCalculator.backgroundColor = UIColor.atlassian.primaryYellow
        
//        createNewGradeSheet.layoutIfNeeded()
//        cumulativeCalculator.layoutIfNeeded()
//        gpaWeightingCalculator.layoutIfNeeded()
//        testScoreCalculator.layoutIfNeeded()
    }
    @IBOutlet weak var createNewGradeSheet: ShadowView!
    @IBOutlet weak var cumulativeCalculator: ShadowView!
    @IBOutlet weak var gpaWeightingCalculator: ShadowView!
    @IBOutlet weak var testScoreCalculator: ShadowView!
}
