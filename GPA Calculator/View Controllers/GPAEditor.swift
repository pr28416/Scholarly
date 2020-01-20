//
//  GPAEditor.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 2/14/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//
var customGPAList: [[[Any]]] = []

import UIKit

class GPAEditor: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabletable.delegate = self
        tabletable.dataSource = self
        tabletable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)


        navigationItem.rightBarButtonItem = editButtonItem
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
        addButton.layer.cornerRadius = addButton.frame.height/2
        for i in customGPAList {
            print(i)
        }
        tabletable.delegate = self
        tabletable.dataSource = self
        tabletable.reloadData()
        
    }
    
    @IBOutlet var tabletable: UITableView!
    @IBOutlet var addButton: UIButton!
    
    @IBAction func addItem(_ sender: UIButton) {
        performSegue(withIdentifier: "addCustom", sender: nil)
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customGPAList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        print(customGPAList)
        if !customGPAList.isEmpty {
            print("Not empty")
            if let text = customGPAList[indexPath.row][0][0] as? String {
                if text.isEmpty {
                    cell.textLabel?.text = "Unnamed"
                } else {
                    cell.textLabel?.text = text
                }
            } else {
                cell.textLabel?.text = "Unnamed"
            }
        } else {
            print("Empty")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedList = customGPAList[indexPath.row]
        print("Selected", selectedList)
        performSegue(withIdentifier: "editCustom", sender: nil)
    }
    
    var selectedList: [[Any]] = [[]]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCustom" {
            let VC = segue.destination as! SubEditor
            VC.editingTable = false
        } else if segue.identifier == "editCustom" {
            let VC = segue.destination as! SubEditor
            VC.currentList = selectedList
            VC.editingTable = true
        }
    }

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            customGPAList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        if editing {
            tabletable.setEditing(true, animated: true)
        } else {
            tabletable.setEditing(false, animated: true)
        }
    }

}
