//
//  TeacherDetailVC.swift
//  DepartmentHMS
//
//  Created by Anish on 12/23/15.
//  Copyright © 2015 Esig. All rights reserved.
//

import UIKit
import CoreData

class TeacherDetailVC: UIViewController {
    
    var selectedTeacherObj:NSManagedObject?

    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(selectedTeacherObj!.valueForKey("teacher_name") as? String)
        nameLbl.text =  selectedTeacherObj!.valueForKey("teacher_name") as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelBtn(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
