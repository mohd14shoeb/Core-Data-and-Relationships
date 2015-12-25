//
//  AppEntryViewController.swift
//  DepartmentHMS
//
//  Created by Anish on 12/25/15.
//  Copyright © 2015 Esig. All rights reserved.
//

import UIKit

class AppEntryViewController: UIViewController {

    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK:-PREPARE FOR SEGUE
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        let addVC = segue.destinationViewController as? AddViewController
        
        guard addVC != nil else{
        
            //its to show all the view list
            _ = segue.destinationViewController as! ViewController
            
            return
            
        }
        if segue.identifier == "addTeacher" {
            
            //show another VC for  teacher
           addVC!.deptOrTeacher = DeptOrTeacherType.Teacher
            
        }else{
            
            //show another VC for deparment
             addVC!.deptOrTeacher = DeptOrTeacherType.Department
            
        }
        
    }
  
}
