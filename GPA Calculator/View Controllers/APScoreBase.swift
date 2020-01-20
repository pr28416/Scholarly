//
//  APScoreBase.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 7/7/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//

import UIKit

class APScoreBase: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    
    let sections = [
        "Arts",
        "English",
        "History & Social Science",
        "Math & Computer Science",
        "Sciences",
        "World Languages & Cultures"
    ]
    
    let Arts = [
        "Art History",
        "Music Theory",
    ]
    
    let English = [
        "English Language and Composition",
        "English Literature and Composition",
    ]
    
    let HistorySocialScience = [
        "Comparative Government",
        "European History",
        "Human Geography",
        "Macroeconomics",
        "Microeconomics",
        "Psychology",
        "United States Government & Politics",
        "United States History",
        "World History",
    ]
    
    let MathCompSci = [
        "Calculus AB",
        "Calculus BC",
        "Computer Science A",
        "Computer Science Principles",
        "Statistics",
    ]
    
    let Science = [
        "Biology",
        "Chemistry",
        "Environmental Science",
        "Physics C: Electricity and Magnetism",
        "Physics C: Mechanics",
        "Physics 1",
        "Physics 2",
    ]
    
    let WorldLanguages = [
        "French Language",
        "German Language",
        "Latin Language",
        "Spanish Language",
        "Spanish Literature"
    ]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 2
        case 2: return 9
        case 3: return 5
        case 4: return 7
        case 5: return 5
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "APSubject", for: indexPath)
        
        switch indexPath.section {
        case 0: cell.textLabel!.text = Arts[indexPath.row]
        case 1: cell.textLabel!.text = English[indexPath.row]
        case 2: cell.textLabel!.text = HistorySocialScience[indexPath.row]
        case 3: cell.textLabel!.text = MathCompSci[indexPath.row]
        case 4: cell.textLabel!.text = Science[indexPath.row]
        case 5: cell.textLabel!.text = WorldLanguages[indexPath.row]
        default: break
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        backButton.layer.cornerRadius = 10
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            let userInterfaceStyle = traitCollection.userInterfaceStyle
            switch userInterfaceStyle {
            case .dark:
                blurBackground.effect = UIBlurEffect(style: .systemChromeMaterialDark)
            case .light:
                blurBackground.effect = UIBlurEffect(style: .systemChromeMaterialLight)
            default:
                blurBackground.effect = UIBlurEffect(style: .systemThickMaterialLight)
            }
        }
        
    }
}
