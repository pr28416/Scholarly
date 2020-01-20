//
//  SATScoreBase.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 9/19/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MainSAT: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        satView.isHidden = false
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var satView: UIView!
    @IBAction func testChanged(_ sender: UISegmentedControl) {
        if let child = self.children[0] as? SATScoreBase {
            switch sender.selectedSegmentIndex {
            case 0:
                child.switchToTest(type: .sat)
            case 1:
                child.switchToTest(type: .psat)
            case 2:
                child.switchToTest(type: .act)
            default:
                break
            }
        }
    }
}

class SATScoreBase: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum subScore: Int {
        case reading = 0,
        writing,
        math
    }
    
    enum test: String {
        case sat = "SAT",
        psat = "PSAT",
        act = "ACT"
    }
    
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var readingScoreLabel: UILabel!
    @IBOutlet weak var writingScoreLabel: UILabel!
    @IBOutlet weak var mathScorelabel: UILabel!
    @IBOutlet weak var yourEstimatedScoreLabel: UILabel!
    
    @IBOutlet weak var readingStack: UIStackView!
    @IBOutlet weak var writingStack: UIStackView!
    @IBOutlet weak var mathStack: UIStackView!
    
    @IBOutlet weak var readingOutOf: UILabel!
    @IBOutlet weak var writingOutOf: UILabel!
    @IBOutlet weak var mathOutOf: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var satSource: [[String]] = []
    var psatSource: [[String]] = []
    
    func data(for type: test) -> [[String]] {
        var source: [[String]] = []
        switch currentTestType {
        case .sat:
            source = satSource
        case .psat:
            source = psatSource
        case .act:
            break
        }
        return source
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data(for: currentTestType).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = data(for: currentTestType)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SATCell", for: indexPath) as! SATScoreCell
        cell.rawScore.text = source[indexPath.row][0]
        cell.mathScore.text = source[indexPath.row][1]
        cell.readingScore.text = source[indexPath.row][2]
        cell.writingScore.text = source[indexPath.row][3]
        return cell
    }
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.view.addGestureRecognizer({
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
            return tap
            }())
        self.view.addGestureRecognizer({
            let swipe = UISwipeGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
            swipe.direction = .down
            return swipe
            }())
        switchToTest(type: currentTestType)
    }
    
    var currentTestType: test = .sat
    
    @IBOutlet weak var tableView: UITableView!
    
    var readingScore = Int()
    var writingScore = Int()
    var mathScore = Int()
    @IBOutlet weak var readingText: UITextField!
    @IBOutlet weak var writingText: UITextField!
    @IBOutlet weak var mathText: UITextField!
    //    var rawReading = Int()
//    var rawWriting = Int()
//    var rawMath = Int()
    
    func switchToTest(type: test) {
        getData(for: type)
        currentTestType = type
        self.navigationController?.navigationBar.topItem?.title = "\(type.rawValue) Calculator"
        self.title = "\(type.rawValue) Calculator"
        switch type {
        case .sat:
            tableViewHeight.constant = 29*58+10
            mathOutOf.text = "/58"
            readingOutOf.text = "/52"
            writingOutOf.text = "/44"
        case .psat:
            tableViewHeight.constant = 29*48+10
            mathOutOf.text = "/48"
            readingOutOf.text = "/47"
            writingOutOf.text = "/44"
        case .act:
            break
        }
        readingText.text = ""
        writingText.text = ""
        mathText.text = ""
        totalScore.text = "0"
        readingScoreLabel.text = "0"
        writingScoreLabel.text = "0"
        mathScorelabel.text = "0"
        readingScore = 0
        writingScore = 0
        mathScore = 0
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
        tableView.reloadData()
    }
    
    func uploadData() {
        var a: [String] = []
        var b: [String] = []
        var c: [String] = []
        var d: [String] = []
        for i in satSource {
            a.append(i[0])
            b.append(i[1])
            c.append(i[2])
            d.append(i[3])
        }
        
        db.collection("Score Tables").document("SAT").setData([
            "Raw Scores": a,
            "Math": b,
            "Reading": c,
            "Writing": d
        ], merge: true)
        
        a = []
        b = []
        c = []
        d = []
        for i in psatSource {
            a.append(i[0])
            b.append(i[1])
            c.append(i[2])
            d.append(i[3])
        }
        
        db.collection("Score Tables").document("PSAT").setData([
            "Raw Scores": a,
            "Math": b,
            "Reading": c,
            "Writing": d
        ], merge: true)
    }
    
    @IBAction func readingEditingEnded(_ sender: UITextField) {
        guard var reading = Int(sender.text!) else {return}
        switch currentTestType {
        case .sat:
            if reading > 52 {reading = 52}
            else if reading < 0 {reading = 0}
            sender.text = "\(reading)"
        case .psat:
            if reading > 47 {reading = 47}
            else if reading < 0 {reading = 0}
            sender.text = "\(reading)"
        case .act:
            break
        }
        readingScore = getScore(reading, forTest: .reading)
        readingScoreLabel.text = "\(readingScore)"
        totalScore.text = "\(readingScore + writingScore + mathScore)"
    }
    @IBAction func writingEditingEnded(_ sender: UITextField) {
        guard var writing = Int(sender.text!) else {return}
        switch currentTestType {
        case .sat:
            if writing > 44 {writing = 44}
            else if writing < 0 {writing = 0}
            sender.text = "\(writing)"
        case .psat:
            if writing > 44 {writing = 44}
            else if writing < 0 {writing = 0}
            sender.text = "\(writing)"
        case .act:
            break
        }
        writingScore = getScore(writing, forTest: .writing)
        writingScoreLabel.text = "\(writingScore)"
        totalScore.text = "\(readingScore + writingScore + mathScore)"
    }
    @IBAction func mathEditingEnded(_ sender: UITextField) {
        guard var math = Int(sender.text!) else {return}
        switch currentTestType {
        case .sat:
            if math > 58 {math = 58}
            else if math < 0 {math = 0}
            sender.text = "\(math)"
        case .psat:
            if math > 48 {math = 48}
            else if math < 0 {math = 0}
            sender.text = "\(math)"
        case .act:
            break
        }
        mathScore = getScore(math, forTest: .math)
        mathScorelabel.text = "\(mathScore)"
        totalScore.text = "\(readingScore + writingScore + mathScore)"
    }
    
    func getData(for test: test) {
        switch test {
        case .sat:
            if let info = UserDefaults.standard.object(forKey: "SAT") as? [[String]] {
                satSource = info
                tableView.reloadData()
            }
            var a: [String] = []
            var b: [String] = []
            var c: [String] = []
            var d: [String] = []
            db.collection("Score Tables").document("SAT").getDocument { (documentSnapshot, err) in
                if let err = err {
                    print("Error: \(err.localizedDescription)")
                } else {
                    if let data = documentSnapshot?.data() {
                        self.satSource = []
                        a = data["Raw Scores"] as! [String]
                        b = data["Math"] as! [String]
                        c = data["Reading"] as! [String]
                        d = data["Writing"] as! [String]
                        for i in 0..<a.count {
                            self.satSource.append([a[i], b[i], c[i], d[i]])
                        }
                    } else {
                        print("Error reading data from snapshot")
                    }
                    self.tableView.reloadData()
                    UserDefaults.standard.set(self.satSource, forKey: "SAT")
                }
            }
        case .psat:
            if let info = UserDefaults.standard.object(forKey: "PSAT") as? [[String]] {
                psatSource = info
                tableView.reloadData()
            }
            var a: [String] = []
            var b: [String] = []
            var c: [String] = []
            var d: [String] = []
            db.collection("Score Tables").document("PSAT").getDocument { (documentSnapshot, err) in
                if let err = err {
                    print("Error: \(err.localizedDescription)")
                } else {
                    if let data = documentSnapshot?.data() {
                        self.psatSource = []
                        a = data["Raw Scores"] as! [String]
                        b = data["Math"] as! [String]
                        c = data["Reading"] as! [String]
                        d = data["Writing"] as! [String]
                        for i in 0..<a.count {
                            self.psatSource.append([a[i], b[i], c[i], d[i]])
                        }
                    } else {
                        print("Error reading data from snapshot")
                    }
                    self.tableView.reloadData()
                    UserDefaults.standard.set(self.psatSource, forKey: "PSAT")
                }
            }
        case .act:
            break
        }
        
    }
    
    func getScore(_ score: Int, forTest test: subScore) -> Int {
        let source = data(for: currentTestType)
        switch test {
        case .math:
            for i in source {
                if i[0] == "\(score)" {
                    return (Int(i[1]) ?? 200)
                }
            }
            return 0
        case .reading:
            for i in source {
                if i[0] == "\(score)" {
                    return (Int(i[2]) ?? 10) * 10
                }
            }
            return 0
        case .writing:
            for i in source {
                if i[0] == "\(score)" {
                    return (Int(i[3]) ?? 10) * 10
                }
            }
            return 0
        }
    }
    
}

class SATScoreCell: UITableViewCell {
    
    @IBOutlet weak var rawScore: UILabel!
    @IBOutlet weak var mathScore: UILabel!
    @IBOutlet weak var readingScore: UILabel!
    @IBOutlet weak var writingScore: UILabel!
}
