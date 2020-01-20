//
//  folderCell.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 2/12/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//

import UIKit

class folderCell: UITableViewCell {

    @IBOutlet var scheduleName: UILabel!
    @IBOutlet var dateCreated: UILabel!
    @IBOutlet var gpaPreview: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
