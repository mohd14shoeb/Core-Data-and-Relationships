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
    
    var selectedTeacherObj:Teachers?
    var deptObj = [Departments]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var deptTableView: UITableView!
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(selectedTeacherObj!.teacher_name)
        self.title =  selectedTeacherObj!.teacher_name
        deptTableView.dataSource = self
        listAllDepartments()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     //MARK: LIST DEPARTMENTS
    func listAllDepartments(){
        
        let context = appDelegate.managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "Departments")
        deptObj = []
        do{
            
            let results = try context.executeFetchRequest(fetchReq)
            deptObj = results as! [Departments]
            
            if deptObj.count > 0{
                
                self.deptTableView.reloadData()
                
            }
            
        }catch{
            
            print((error as NSError).localizedDescription)
            
        }
          
    }
      //MARK: ADD TEACHER TO THIS DEPARTMENT
    func addTeacherToThisDepartment(sender:UIButton){
        //mark as added
        
        
        
        
        
        
        
        
    }

}
//MARK: TABLE VIEW DATASOURCE AND DELEGATE METHODS
extension TeacherDetailVC :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deptObj.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("teacherCell", forIndexPath: indexPath) as! TeacherTblVIewCell
        print(deptObj[indexPath.row].dept_name)
        cell.teacherName?.text = deptObj[indexPath.row].dept_name
        cell.deleteBtn.addTarget(self, action: "addTeacherToThisDepartment:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.deleteBtn.layer.borderWidth = 2.0
        return cell
        
    }

}



