//
//  CumulativeCalculator.swift
//  GPA Calculator
//
//  Created by Administrator on 4/8/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//

import UIKit

class CumulativeCalculator: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("globalStorage count:", globalStorage.count)
        return globalStorage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cumulativeCell", for: indexPath) as! folderCell
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFolders[indexPath.row] = true
        calcAvgs()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedFolders[indexPath.row] = false
        calcAvgs()
    }
    
    func calcAvgs() {
        if selectedFolders == [Bool](repeating: false, count: globalStorage.count) {
            unweightedCumulative.text = "N/A"
            weightedCumulative.text = "N/A"
        } else {
            var count = 0
            var usum = 0.0
            var wsum = 0.0
            for item in 0...globalStorage.count-1 {
                if selectedFolders[item] == true {
                    count += 1
                    usum += globalStorage[item][0][9] as! Double
                    wsum += globalStorage[item][0][10] as! Double
                }
            }
            usum = Double(round(1000*usum)/1000)
            wsum = Double(round(1000*wsum)/1000)
            unweightedCumulative.text = "\(usum/Double(count))"
            weightedCumulative.text = "\(wsum/Double(count))"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedFolders = [Bool](repeating: false, count: globalStorage.count)

        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        backImage.layer.masksToBounds = true
        backImage.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 15
        
        if globalStorage.count == 0 {
            tableView.isHidden = true
            backImage.isHidden = true
        } else {
            tableView.isHidden = false
            backImage.isHidden = false
        }
    }

    @IBOutlet var tableView: UITableView!
    @IBOutlet var unweightedCumulative: UILabel!
    @IBOutlet var weightedCumulative: UILabel!
    @IBOutlet var backImage: UIImageView!
    
    var selectedFolders = [Bool]()
    
    
}
