//
//  GPACalcHome.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 2/9/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.


import UIKit
import GoogleMobileAds

var globalStorage: [[[Any]]] = []
var currentSelectedCustomGPA: [[Any]] = []
var currentGPAtype = 1

class MainContainerVC: UIViewController, GADBannerViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBar.layer.masksToBounds = true
        sideBar.layer.cornerRadius = 10
        sideBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
//        screenView.layer.masksToBounds = true
//        screenView.layer.cornerRadius = 10
//        screenView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        mainAd.adUnitID = appIDs["Personal"]
        
        mainAd.rootViewController = self
        
        mainAd.adSize = kGADAdSizeSmartBannerPortrait
        //bottomAdBanner.layer.backgroundColor = UIColor(red: 72/255, green: 166/255, blue: 225/255, alpha: 1).cgColor
        let request = GADRequest()
        request.testDevices = [(kGADSimulatorID as! String), "5580b527b038bb6a5b446a62eb9843a1", "b419f0f9412570e89cafe7b94bac2fb3", "08eb229a0d133997fa39a222ee820480",
                               "d822676b5fb97ac57b3d86280a38d10d"]
        mainAd.load(request)
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSlidingMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        
    }
    @IBOutlet var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet var screenView: UIView!
    @IBOutlet var sideBar: UIView!
    
    @IBOutlet var mainAd: GADBannerView!
    @IBOutlet var adBottomConstraint: NSLayoutConstraint!
    
    var sideMenuVisible = false
    
    @objc func toggleSlidingMenu() {
        if sideMenuVisible {
            sideMenuConstraint.constant = -240
        } else {
            sideMenuConstraint.constant = 0
            
        }
        screenView.isUserInteractionEnabled = !screenView.isUserInteractionEnabled
        sideMenuVisible = !sideMenuVisible
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            if self.sideMenuVisible {
                self.screenView.alpha = 0.5
            } else {
                self.screenView.alpha = 1
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        
        adBottomConstraint.constant = 50
        print(adBottomConstraint.constant)
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.adBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        print(adBottomConstraint.constant)
    }
    
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription).")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}


class sideMenu: UITableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hapticImpact(feedback: .medium)
        switch indexPath.row {
        case 0:
            if indexPath.section == 0 {
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("showGPAEditor"), object: nil)
            }
            
        case 1: NotificationCenter.default.post(name: NSNotification.Name("showSavedSchedules"), object: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("showCumulativeCalc"), object: nil)
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name("APScore"), object: nil)
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name("SATScore"), object: nil)
        default: break
        }
    }
    
}

class GPACalcHome: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBAction func toggleSlidingMenu(_ sender: UIBarButtonItem) {
        hapticImpact(feedback: .medium)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func showSavedSchedules() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        performSegue(withIdentifier: "showSavedSchedules", sender: nil)
    }
    @objc func showGPAEditor() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        performSegue(withIdentifier: "customGPAs", sender: nil)
    }
    @objc func showCumulativeCalculator() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        performSegue(withIdentifier: "showCumulativeCalc", sender: nil)
    }
    @objc func showAPScoreCalculator() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        performSegue(withIdentifier: "APScore", sender: nil)
    }
    @objc func showSATScoreCalculator() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        performSegue(withIdentifier: "SATScore", sender: nil)
    }
    
    @IBOutlet var backview: UIView!
    
    var classInfo = [
        ["", 0, 4.33, 0.0, "College Prep", 0, "Unnamed", "", 0, 0.0, 0.0] // [class name, grade index, weight for grade, credits, type, type index, ClassInfo Schedule name, schedule ID (UUID), timestamp]
    ]
    
    var unweightedGPA = Double()
    var weightedGPA = Double()
    
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Save Schedule", message: "Enter a name to save this schedule.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Schedule name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            
            if !self.classInfo.isEmpty {
                for i in 0...self.classInfo.count-1 {
                    if let text = alert.textFields?[0].text {
                        if text.isEmpty {
                            self.classInfo[i][6] = "Unnamed"
                        } else {
                            self.classInfo[i][6] = text
                        }
                    }
                    self.classInfo[i][9] = self.unweightedGPA
                    self.classInfo[i][10] = self.weightedGPA
                }
                
                if !globalStorage.isEmpty {
                    for selectionIndex in 0...globalStorage.count-1 {
                        if globalStorage[selectionIndex][0][7] as! String == self.classInfo[0][7] as! String {
                            
                            let note = UIAlertController(title: "Overwrite schedule?", message: "This schedule already exists. Would you like to overwrite the existing schedule or save as a new schedule?", preferredStyle: .alert)
                            
                            note.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
                                globalStorage[selectionIndex] = self.classInfo
                                let confirmation = UIAlertController(title: "Successfully saved", message: "Your existing schedule has been successfully overwritten.", preferredStyle: .alert)
                                confirmation.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(confirmation, animated: true, completion: nil)
                            }))
                            
                            
                            
                            note.addAction(UIAlertAction(title: "Save as new", style: .default, handler: { (action) in
                                
                                let uuid = UUID().uuidString
                                let timeStamp = NSDate()
                                
                                for item in 0...self.classInfo.count-1 {
                                    self.classInfo[item][7] = "\(uuid)"
                                    self.classInfo[item][8] = timeStamp
                                }
                                
                                globalStorage.insert(self.classInfo, at: 0)
                                let confirmation = UIAlertController(title: "Successfully saved", message: "You have successfully added a new schedule.", preferredStyle: .alert)
                                confirmation.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(confirmation, animated: true, completion: nil)
                                
                            }))
                            
                            
                            
                            note.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            
                            
                            
                            self.present(note, animated: true, completion: nil)
                            break
                        } else {
                            
                            let uuid = UUID().uuidString
                            let timeStamp = NSDate()
                            for item in 0...self.classInfo.count-1 {
                                self.classInfo[item][7] = "\(uuid)"
                                self.classInfo[item][8] = timeStamp
                            }
                            
                            globalStorage.insert(self.classInfo, at: 0)
                            
                            let confirmation = UIAlertController(title: "Successfully saved", message: "You have successfully added a new schedule.", preferredStyle: .alert)
                            
                            confirmation.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            self.present(confirmation, animated: true, completion: nil)
                            break
                        }
                        
                    }
                } else {
                    let uuid = UUID().uuidString
                    let timeStamp = NSDate()
                    for item in 0...self.classInfo.count-1 {
                        self.classInfo[item][7] = "\(uuid)"
                        self.classInfo[item][8] = timeStamp
                    }
                    globalStorage.insert(self.classInfo, at: 0)
                    let confirmation = UIAlertController(title: "Successfully saved", message: "You have successfully added a new schedule.", preferredStyle: .alert)
                    confirmation.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(confirmation, animated: true, completion: nil)
                    
                }
            } else {
                let errorAlert = UIAlertController(title: "Empty schedule", message: "You need to put in some classes before you save!", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var weightedText: UILabel!
    var GPA = 0.00
    var possibleGrades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"] // mod 13
    
    // Weighted Honors A = 4.33
    
    var cpGrades433: [Double] = [4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 1.33, 1.00, 0.67, 0.00]
    var honorsGrades433: [Double] = [4.67, 4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 1.33, 1.00, 0.00]
    var ap_ibGrades433: [Double] = [5.00, 4.67, 4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 1.33, 0.00]
    
    // Weighted Honors A = 4.5
    
    var cpGrades45: [Double] = [4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 1.33, 1.00, 0.67, 0.00]
    var honorsGrades45: [Double] = [4.83, 4.50, 4.17, 3.83, 3.50, 3.17, 2.83, 2.50, 2.17, 1.83, 1.50, 1.17, 0.00]
    var ap_ibGrades45: [Double] = [5.33, 5.00, 4.67, 4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 0.00]
    
    //-----------
    
    @IBOutlet var viewBar: UIView!
    
    @IBOutlet var toolbar: UIToolbar!
    var list = ["College Prep", "Honors", "AP", "IB"]
    var gpaTypes = ["Weighted GPA: Honors A = 4.33", "Weighted GPA: Honors A = 4.50"]
    
    @IBOutlet var cumulativeGPA: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toolbar.layer.masksToBounds = true
        // toolbar.clipsToBounds = true
        toolbar.layer.cornerRadius = 13
        toolbar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        viewBar.layer.cornerRadius = 13
        viewBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
//        backview.layer.masksToBounds = true
//        backview.layer.cornerRadius = 13
//        backview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSavedSchedules), name: NSNotification.Name("showSavedSchedules"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGPAEditor), name: NSNotification.Name("showGPAEditor"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCumulativeCalculator), name: NSNotification.Name("showCumulativeCalc"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAPScoreCalculator), name: NSNotification.Name("APScore"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSATScoreCalculator), name: NSNotification.Name("SATScore"), object: nil)
        
        print("\n\nGoogle Admob SDK version: \(GADRequest.sdkVersion())\n\n")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        classAddButton.layer.masksToBounds = true
        classAddButton.layer.cornerRadius = 15
        
        //bottomAdBanner.adUnitID = appIDs["Personal"]
//        bottomAdBanner.adUnitID = "ca-app-pub-9627927177527193/7783150662"
        
        //bottomAdBanner.rootViewController = self
        
        //bottomAdBanner.adSize = kGADAdSizeSmartBannerPortrait
        //bottomAdBanner.layer.backgroundColor = UIColor(red: 72/255, green: 166/255, blue: 225/255, alpha: 1).cgColor
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID, "5580b527b038bb6a5b446a62eb9843a1", "b419f0f9412570e89cafe7b94bac2fb3", "08eb229a0d133997fa39a222ee820480",
//            "d822676b5fb97ac57b3d86280a38d10d"]
//        bottomAdBanner.load(request)
        
        currentSelectedCustomGPA = []
        
        currentGPAtype = 1
        
        navigationItem.rightBarButtonItem = editButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(GPACalcHome.keyboardWillShow), name: UIApplication.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GPACalcHome.keyboardWillHide), name: UIApplication.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(calculateUnweightedGPA), name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(calculateWeightedGPA), name: NSNotification.Name("calculateWeightedGPA"), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBOutlet var heightOfAdBanner: NSLayoutConstraint!
  
    /*  ["", 0, 4.33, 0.0, "College Prep", 0]
     [class name, grade index, weight for grade, credits, type, type index]
     */
    @objc func calculateUnweightedGPA() {
        var sum: Double = 0.0
        var creditSum: Double = 0.0
        if !classInfo.isEmpty {
            for i in 0...classInfo.count-1 {
                sum += (classInfo[i][2] as! Double)*(classInfo[i][3] as! Double)
                creditSum += classInfo[i][3] as! Double
            }
            if creditSum == 0 {
                
                cumulativeGPA.text = "Unweighted: N/A"
            } else {
                var value: Double = Double(round(1000*(sum/Double(creditSum)))/1000)
                value = Double(round(10000*value)/10000)
                
                cumulativeGPA.text = "Unweighted: \(value)"
                unweightedGPA = value
            }
        } else {
            cumulativeGPA.text = "Unweighted: N/A"
        }
        
    }
    
    // [class name, grade index, weight for grade, credits, type, type index, ClassInfo Schedule name, schedule ID (UUID), timestamp]
    
    @objc func calculateWeightedGPA() {
        if currentGPAtype == 1 {
            
            var sum: Double = 0.0
            var creditSum: Double = 0.0
            if !classInfo.isEmpty {
                for row in 0...classInfo.count-1 {
                    switch classInfo[row][4] as! String {
                    case "College Prep":
                        sum += cpGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "Honors":
                        sum += honorsGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "AP":
                        sum += ap_ibGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "IB":
                        sum += ap_ibGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    default:
                        sum += cpGrades45[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    }
                    creditSum += classInfo[row][3] as! Double
                }
                
                if creditSum == 0 {
                    
                    weightedText.text = "Weighted: N/A"
                } else {
                    var value: Double = Double(round(1000*(sum/Double(creditSum)))/1000)
                    value = Double(round(10000*value)/10000)
                    
                    weightedText.text = "Weighted: \(value)"
                    weightedGPA = value
                }
            } else {
                weightedText.text = "Weighted: N/A"
            }


        } else if currentGPAtype == 0 {
            var sum: Double = 0.0
            var creditSum: Double = 0.0
            if !classInfo.isEmpty {
                for row in 0...classInfo.count-1 {
                    switch classInfo[row][4] as! String {
                    case "College Prep":
                        sum += cpGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "Honors":
                        sum += honorsGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "AP":
                        sum += ap_ibGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    case "IB":
                        sum += ap_ibGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    default:
                        sum += cpGrades433[classInfo[row][1] as! Int]*(classInfo[row][3] as! Double)
                    }
                    creditSum += classInfo[row][3] as! Double
                }

                if creditSum == 0 {
                    
                    weightedText.text = "Weighted: N/A"
                } else {
                    var value: Double = Double(round(1000*(sum/Double(creditSum)))/1000)
                    value = Double(round(10000*value)/10000)
                    
                    weightedText.text = "Weighted: \(value)"
                    weightedGPA = value
                }
            } else {
                weightedText.text = "Weighted: N/A"
            }
            
            
            
        } else if currentGPAtype == 2 {
            var sum: Double = 0.0
            var creditSum: Double = 0.0
            if !classInfo.isEmpty {
                
                for row in 0...classInfo.count-1 {
                    switch classInfo[row][4] as! String {
                    case "College Prep":
                        sum += currentSelectedCustomGPA[ (classInfo[row][1] as! Int) + 1 ][2] as! Double * (classInfo[row][3] as! Double)
                    case "Honors":
                        sum += currentSelectedCustomGPA[ (classInfo[row][1] as! Int) + 1 ][3] as! Double * (classInfo[row][3] as! Double)
                    case "AP":
                        print(
                            classInfo[row][1],
                            type(of: (currentSelectedCustomGPA[(classInfo[row][1] as! Int) + 1][4])),
                            classInfo[row][3])
                        
                        
                        sum += (currentSelectedCustomGPA[(classInfo[row][1] as! Int) + 1][4]) as! Double * (classInfo[row][3] as! Double)
                        
                    case "IB":
                        sum += currentSelectedCustomGPA[ (classInfo[row][1] as! Int) + 1 ][4] as! Double * (classInfo[row][3] as! Double)
                    default:
                        sum += currentSelectedCustomGPA[ (classInfo[row][1] as! Int) + 1 ][2] as! Double * (classInfo[row][3] as! Double)
                    }
                    creditSum += classInfo[row][3] as! Double
                    
                }
                
                if creditSum == 0 {
                    
                    weightedText.text = "Weighted: N/A"
                } else {
                    var value: Double = Double(round(1000*(sum/Double(creditSum)))/1000)
                    value = Double(round(10000*value)/10000)
                    
                    weightedText.text = "Weighted: \(value)"
                    weightedGPA = value
                }
                
            }
        }
    }
/*  ["", 0, 4.33, 0.0, "College Prep", 0]
    [class name, grade index, weight for grade, credits, type, type index]
*/
    
    
    @IBAction func changeGPAType(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Select GPA Type", message: nil, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: gpaTypes[0], style: .default) { (action) in
            currentGPAtype = 0
            NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
            currentSelectedCustomGPA = []
            print("Current GPA Type:", currentGPAtype)
        }
        
        let secondAction = UIAlertAction(title: gpaTypes[1], style: .default) { (action) in
            currentGPAtype = 1
            NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
            currentSelectedCustomGPA = []
            print("Current GPA Type:", currentGPAtype)
        }
        
        let moreAction = UIAlertAction(title: "Select from Custom GPA Editor List", style: .default) { (action) in
            self.performSegue(withIdentifier: "showMoreGPATypes", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(moreAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classInfo.count
    }
    
    @IBAction func courseEditingEnded(_ sender: AnyObject) {
        let cell = sender.superview?.superview?.superview as! classCell
        let indexPath = calculationTable.indexPath(for: cell)
        if let className = cell.classNameField.text, let index = indexPath?.row {
            if index >= 0 && index < classInfo.count{ classInfo[index][0] = className } else { print("Apparently out of bounds: \(index)")}
        }
        print("\nModified table")
        if !classInfo.isEmpty {
            for i in 0...classInfo.count-1 {
                print("\(i): \(classInfo[i])")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! classCell
        
        cell.classType.text = list[classInfo[indexPath.row][5] as! Int]
        cell.creditControl.value = classInfo[indexPath.row][3] as! Double
        cell.creditNum.text = "\(classInfo[indexPath.row][3])"
        cell.creditNum.text = "\(cell.creditControl.value)"
        cell.blackOverlay.layer.cornerRadius = 10
        cell.classNameField.delegate = self as? UITextFieldDelegate
        cell.numberRow.text = "\(indexPath.row + 1)"
        cell.numberRow.layer.cornerRadius = 12.0
        cell.pickerView.layer.cornerRadius = cell.pickerView.frame.width/6
        cell.pickerView.selectRow(classInfo[indexPath.row][1] as! Int, inComponent: 0, animated: false)
        cell.creditControl.layer.cornerRadius = cell.creditControl.frame.height / 2
        cell.leftButton.layer.cornerRadius = 3
        cell.rightButton.layer.cornerRadius = 3
        cell.leftButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        cell.rightButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        cell.creditControl.layer.borderColor = UIColor.white.cgColor
        cell.creditControl.layer.borderWidth = 1
        cell.creditControl.layer.masksToBounds = true
        
        for i in [1, 2] {
//            cell.pickerView.subviews[i].isHidden = true
        }
        
        if let text = classInfo[indexPath.row][0] as? String {
            cell.classNameField.text = text
        }
        
        
        return cell
    }
    //------------------
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            calculationTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 80, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            calculationTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func newSchedule(_ sender: UIBarButtonItem) {
        classInfo.removeAll()
        print("Removed ALL: \(classInfo)")
        calculationTable.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
    }
    //------------------
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! classCell
        cell.classNameField.endEditing(true)
        if editingStyle == .delete {
            print("\nDeleted item from table: \(classInfo[indexPath.row])")
            classInfo.remove(at: indexPath.row)
            print("\n")
            
            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { /*tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.none);*/ tableView.reloadData()})
            if !classInfo.isEmpty {
                for i in 0...classInfo.count-1 {
                    print("\(i): \(classInfo[i])")
                }
                print("\n")
            }
            NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
        }
    }
    
    @IBOutlet var calculationTable: UITableView!
    
    // UIPICKERVIEW ----------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return possibleGrades.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            
            return possibleGrades[row]
            
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = possibleGrades[row]
        pickerLabel.font = UIFont(name: "Avenir Heavy", size: 30)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    /*  ["", 0, 4.33, 0.0, "College Prep", 0]
     [class name, grade index, weight for grade, credits, type, type index]
     */
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 27
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let cell = pickerView.superview?.superview?.superview as! classCell
            let indexPath = calculationTable.indexPath(for: cell)
            
            classInfo[(indexPath?.row)!][1] = row
            
            switch row {
            case 0:
                classInfo[(indexPath?.row)!][2] = 4.33
            case 1:
                classInfo[(indexPath?.row)!][2] = 4.00
            case 2:
                classInfo[(indexPath?.row)!][2] = 3.67
            case 3:
                classInfo[(indexPath?.row)!][2] = 3.33
            case 4:
                classInfo[(indexPath?.row)!][2] = 3.00
            case 5:
                classInfo[(indexPath?.row)!][2] = 2.67
            case 6:
                classInfo[(indexPath?.row)!][2] = 2.33
            case 7:
                classInfo[(indexPath?.row)!][2] = 2.00
            case 8:
                classInfo[(indexPath?.row)!][2] = 1.67
            case 9:
                classInfo[(indexPath?.row)!][2] = 1.33
            case 10:
                classInfo[(indexPath?.row)!][2] = 1.00
            case 11:
                classInfo[(indexPath?.row)!][2] = 0.67
            case 12:
                classInfo[(indexPath?.row)!][2] = 0.00
            default:
                classInfo[(indexPath?.row)!][2] = 4.33
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
            
            print("\nModified grade in table: \(classInfo[(indexPath?.row)!])")
            print("\n")
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 1 {
            let titleData = possibleGrades[row]
            let attributedString = NSAttributedString(string: titleData, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font:UIFont(name: "Avenir", size: 40.0)!
                ])
            return attributedString
        } else if pickerView.tag == 2 {
            let titleData = possibleGrades[row]
            let attributedString = NSAttributedString(string: titleData, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white
                ])
            return attributedString
        }
        return nil
    }
    
    //-----------------------
    @IBAction func hapticAddClass(_ sender: UIButton) {
        hapticImpact(feedback: .medium)
    }
    
    @IBAction func addClass(_ sender: UIButton) {
        
        classInfo.append(["", 0, 4.33, 0.0, "College Prep", 0, "Unnamed", "", 0, 0.0, 0.0])
        calculationTable.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
        
        if !classInfo.isEmpty {
            print("\nAdded new item")
            for i in 0...classInfo.count-1 {
                print("\(i): \(classInfo[i])")
            }
            print("\n")
        }
    }
    
    @IBOutlet var classAddButton: UIButton!
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        if editing {
            calculationTable.setEditing(true, animated: true)
        } else {
            calculationTable.setEditing(false, animated: true)
        }

    }
    @IBAction func capture(_ sender: UIBarButtonItem) {
        if !classInfo.isEmpty{
        print("\nCapturing")
        for i in 0...classInfo.count-1 {
            print("\(i): \(classInfo[i])")
        }
        print("\n")
        }
    }
    
    @IBAction func creditsChanged(_ sender: UIStepper) {
        let cell = sender.superview?.superview?.superview as! classCell
        let indexPath = calculationTable.indexPath(for: cell)
        classInfo[(indexPath?.row)!][3] = cell.creditControl.value
        cell.creditNum.text = "\(cell.creditControl.value)"
        NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
    }
    
    @IBAction func rightCourse(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview?.superview as! classCell
        let indexPath = calculationTable.indexPath(for: cell)
        
        if classInfo[(indexPath?.row)!][5] as! Int == cell.typeList.count-1 {
            cell.classType.text = cell.typeList[0]
            classInfo[(indexPath?.row)!][4] = cell.typeList[0]
            classInfo[(indexPath?.row)!][5] = 0
        } else {
            cell.classType.text = cell.typeList[classInfo[(indexPath?.row)!][5] as! Int + 1]
            classInfo[(indexPath?.row)!][5] = classInfo[(indexPath?.row)!][5] as! Int + 1
            classInfo[(indexPath?.row)!][4] = cell.typeList[classInfo[(indexPath?.row)!][5] as! Int]
            
        }
        NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
    }
    
    @IBAction func hapticLeftCourse(_ sender: UIButton) {
        hapticImpact(feedback: .light)
    }
    @IBAction func hapticRightCourse(_ sender: UIButton) {
        hapticImpact(feedback: .light)
    }
    @IBAction func hapticStepper(_ sender: UIStepper) {
        hapticImpact(feedback: .light)
    }
    
    
    @IBAction func leftCourse(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview?.superview as! classCell
        let indexPath = calculationTable.indexPath(for: cell)
        
        if classInfo[(indexPath?.row)!][5] as! Int == 0 {
            cell.classType.text = cell.typeList[cell.typeList.count-1]
            classInfo[(indexPath?.row)!][4] = cell.typeList[cell.typeList.count-1]
            classInfo[(indexPath?.row)!][5] = cell.typeList.count-1

        } else {
            cell.classType.text = cell.typeList[classInfo[(indexPath?.row)!][5] as! Int - 1]
            classInfo[(indexPath?.row)!][5] = classInfo[(indexPath?.row)!][5] as! Int - 1
            classInfo[(indexPath?.row)!][4] = cell.typeList[classInfo[(indexPath?.row)!][5] as! Int]
        }
        NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
    }
    
}


class selectGPAType: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customGPAList.count
    }
    
    /*
     customGPAList = [
     [
     ["Custom name", "UUID"],
     ["A+", "cp weight", "honors weight", "ap/ib weight"], ...
     ],
     [],
     [],
     [],
     []
     ]
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectCustomCell", for: indexPath)
        cell.textLabel?.text = String(describing: customGPAList[indexPath.row][0][0])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            currentSelectedCustomGPA = customGPAList[indexPath.row]
            currentGPAtype = 2
            print("New: \n\(currentSelectedCustomGPA)")
            NotificationCenter.default.post(name: NSNotification.Name("calculateUnweightedGPA"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("calculateWeightedGPA"), object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
