//
//  DepartmentTblViewCell.swift
//  DepartmentHMS
//
//  Created by Anish on 12/25/15.
//  Copyright © 2015 Esig. All rights reserved.
//

import UIKit

class DepartmentTblViewCell: UITableViewCell {
    
    
    @IBOutlet weak var deptNameLbl: UILabel!
    @IBOutlet weak var deptDeleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
