//
//  LeaderboardHomeVC.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/26/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class LeaderboardHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath)
        return cell
    }
    
    @IBOutlet weak var newButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        newButton.showsMenuAsPrimaryAction = true
        newButton.menu = {
            let menu = UIMenu(title: "", image: nil, identifier: .none, options: .displayInline, children: [
                UIAction(title: "Create new room", image: nil, identifier: .none, discoverabilityTitle: nil, state: .off, handler: { (_) in
                    print("Create new room")
                }),
                UIAction(title: "Join room with code", image: nil, identifier: .none, discoverabilityTitle: nil, state: .off, handler: { (_) in
                    print("Join room with code")
                })
            ])
            return menu
        }()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
