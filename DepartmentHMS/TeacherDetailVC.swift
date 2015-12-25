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
    var allDeptsForTheTeacher = [Departments]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var deptTableView: UITableView!{
        
        didSet{
            
            deptTableView.dataSource = self
            deptTableView.delegate = self
            
        }
        
    }
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  selectedTeacherObj!.teacher_name
        addSaveButtonToNavigationBar()
        listAllDepartments()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ADD SAVE BAR BUTTON AND ITS ACTION
    func addSaveButtonToNavigationBar(){
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveSelectedDepartmentsToThisTeacher")
        navigationItem.rightBarButtonItem = saveButton
        
    }
    func saveSelectedDepartmentsToThisTeacher() {
        
        
        
        
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
    //MARK: ADD/DELETE TEACHER TO THIS DEPARTMENT
    func addTeacherToThisDepartment(sender:UIButton){
        
        if allDeptsForTheTeacher.contains(deptObj[sender.tag]){
            
            sender.setBackgroundImage(nil, forState: UIControlState.Normal)
            let indexToRemove =  allDeptsForTheTeacher.indexOf(deptObj[sender.tag])
            allDeptsForTheTeacher.removeAtIndex(indexToRemove!)
            
        }else{
            //save it in array other wise not
            sender.setBackgroundImage(UIImage(named: "tick"), forState: UIControlState.Normal)
            allDeptsForTheTeacher.append( deptObj[sender.tag])
            
        }
        
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
        if allDeptsForTheTeacher.contains(deptObj[indexPath.row]){
            
            cell.deleteBtn.setBackgroundImage(UIImage(named: "tick"), forState: UIControlState.Normal)
            
        }else{
            
             cell.deleteBtn.setBackgroundImage(nil, forState: UIControlState.Normal)
            
        }
        
        cell.deleteBtn.layer.borderWidth = 2.0
        cell.deleteBtn.tag = indexPath.row
        return cell
        
        
    }
    
}



