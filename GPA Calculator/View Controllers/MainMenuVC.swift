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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBOutlet weak var createNewGradeSheet: ShadowView!
    @IBOutlet weak var cumulativeCalculator: ShadowView!
    @IBOutlet weak var gpaWeightingCalculator: ShadowView!
    @IBOutlet weak var testScoreCalculator: ShadowView!
}
