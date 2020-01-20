//
//  SubEditor.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 2/14/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//

import UIKit

class SubEditor: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBOutlet var navigation_bar: UINavigationBar!
    
    @IBOutlet var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        print(currentList[0][0])
        if let name = currentList[0][0] as? String {
            nameField.text = name
        }
        
        navigation_bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigation_bar.shadowImage = UIImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GPACalcHome.keyboardWillShow), name: UIApplication.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GPACalcHome.keyboardWillHide), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    var editingTable = false
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if editingTable == false { // Adding new
            let alert = UIAlertController(title: "Save new file?", message: "Do you want to save this custom GPA weight file?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save as new", style: .default, handler: { (action) in
                let uuid = UUID()
                self.currentList[0][1] = "\(uuid)"
                customGPAList.append(self.currentList)
                
                let userDefaults = UserDefaults.standard
                userDefaults.self.set(customGPAList, forKey: "customGPAList")
                
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Discard changes", style: .destructive, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else { // Editing
            for i in 0...customGPAList.count-1 {
                print(customGPAList[i][0][1])
                let one = String(describing: customGPAList[i][0][1])
                let two = String(describing: currentList[0][1])
                if one == two {
                    let alert = UIAlertController(title: "Overwrite existing?", message: "Do you want to overwrite the existing custom GPA weight file?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
                        customGPAList[i] = self.currentList
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.self.set(customGPAList, forKey: "customGPAList")
                        
                        self.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Save as new", style: .default, handler: { (action) in
                        let uuid = UUID()
                        self.currentList[0][1] = "\(uuid)"
                        customGPAList.append(self.currentList)
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.self.set(customGPAList, forKey: "customGPAList")
                        
                        self.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Discard changes", style: .destructive, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    var currentList: [[Any]] = [
        ["Unnamed", "UUID"],// [Custom name, UUID]
        ["A+", 0, 0.00, 0.00, 0.00],// [grade, grade index, cp weight, honors weight, ap/ib weight
        ["A", 1, 0.00, 0.00, 0.00],
        ["A-", 2, 0.00, 0.00, 0.00],
        ["B+", 3, 0.00, 0.00, 0.00],
        ["B", 4, 0.00, 0.00, 0.00],
        ["B-", 5, 0.00, 0.00, 0.00],
        ["C+", 6, 0.00, 0.00, 0.00],
        ["C", 7, 0.00, 0.00, 0.00],
        ["C-", 8, 0.00, 0.00, 0.00],
        ["D+", 9, 0.00, 0.00, 0.00],
        ["D", 10, 0.00, 0.00, 0.00],
        ["D-", 11, 0.00, 0.00, 0.00],
        ["F", 12, 0.00, 0.00, 0.00],
    ]
    
    @IBAction func nameEditingEnded(_ sender: UITextField) {
        if let name = nameField.text {
            currentList[0][0] = "\(name)"
        } else {
            currentList[0][0] = "Unnamed"
        }
    }
    
    @IBAction func cpWeightEditingEnded(_ sender: UITextField) {
        let cell = sender.superview?.superview?.superview as! subCell
        let indexPath = weightTable.indexPath(for: cell)
        if cell.cpField.text!.isEmpty {
            currentList[(indexPath?.row)!+1][2] = 0.00
        } else {
            if let item = Double(cell.cpField.text!) {
                currentList[(indexPath?.row)!+1][2] = item
            } else {
                currentList[(indexPath?.row)!+1][2] = 0.00
            }
            
        }
        weightTable.reloadData()
    }
    @IBAction func honorsEditingEnded(_ sender: UITextField) {
        let cell = sender.superview?.superview?.superview as! subCell
        let indexPath = weightTable.indexPath(for: cell)
        if cell.honorsField.text!.isEmpty {
            currentList[(indexPath?.row)!+1][3] = 0.00
        } else {
            if let item = Double(cell.honorsField.text!) {
                currentList[(indexPath?.row)!+1][3] = item
            } else {
                currentList[(indexPath?.row)!+1][3] = 0.00
            }
            
        }
        weightTable.reloadData()
    }
    @IBAction func ap_ibEditingEnded(_ sender: UITextField) {
        let cell = sender.superview?.superview?.superview as! subCell
        let indexPath = weightTable.indexPath(for: cell)
        if cell.ap_ibFIeld.text!.isEmpty {
            currentList[(indexPath?.row)!+1][4] = 0.00
        } else {
            if let item = Double(cell.ap_ibFIeld.text!) {
                currentList[(indexPath?.row)!+1][4] = item
            } else {
                currentList[(indexPath?.row)!+1][4] = 0.00
            }
            
        }
        weightTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coolCell", for: indexPath) as! subCell
        if let text = currentList[indexPath.row+1][0] as? String {
            cell.grade.text = text
        }
        
        cell.cpField.text = "\(currentList[indexPath.row+1][2])"
        cell.honorsField.text = "\(currentList[indexPath.row+1][3])"
        cell.ap_ibFIeld.text = "\(currentList[indexPath.row+1][4])"
        
        return cell
    }
    
    @IBOutlet var weightTable: UITableView!
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            weightTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 80, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            weightTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

}
