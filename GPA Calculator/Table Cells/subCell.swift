//
//  subCell.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 2/14/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//

import UIKit

class subCell: UITableViewCell {
    
    @IBOutlet var grade: UILabel!
    @IBOutlet var cpField: UITextField!
    @IBOutlet var honorsField: UITextField!
    @IBOutlet var ap_ibFIeld: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }

}
