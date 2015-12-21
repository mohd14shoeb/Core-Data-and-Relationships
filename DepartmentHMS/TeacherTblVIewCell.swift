//
//  TeacherTblVIewCell.swift
//  DepartmentHMS
//
//  Created by Bikram on 12/10/15.
//  Copyright © 2015 Esig. All rights reserved.
//

import UIKit

class TeacherTblVIewCell: UITableViewCell {
    
    @IBOutlet weak var teacherName: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
