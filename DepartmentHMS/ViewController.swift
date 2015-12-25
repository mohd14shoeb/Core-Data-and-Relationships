//
//  ViewController.swift
//  DepartmentHMS
//
//  Created by Bikram on 12/10/15.
//  Copyright © 2015 Esig. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UIViewController {
    
    @IBOutlet weak var addStdnBtn: UIButton!
    @IBOutlet weak var viewTeachertblView: UITableView!
    @IBOutlet weak var teacherDeptSegCntrl: UISegmentedControl!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var teacherObj = [Teachers]()
    var deptObj = [Departments]()
    var selectedSegment = Int()
    
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewTeachertblView.delegate = self
        viewTeachertblView.dataSource = self
        listAllTeachers()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func teachDeptSegmCntrl(sender: AnyObject) {
        
        
        let segmentedCntrl = sender as! UISegmentedControl
        selectedSegment = segmentedCntrl.selectedSegmentIndex
        
        if selectedSegment == 0{
            
            listAllTeachers()
            
        }else{
            
            ListAllDepartments()
            
        }
        
    }
    
    
    //MARK: LIST ALL TEACHERS
    func listAllTeachers(){
        
        let context = appDelegate.managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "Teachers")
        teacherObj = []
        do{
            
            let results = try context.executeFetchRequest(fetchReq)
            teacherObj = results as! [Teachers]
            viewTeachertblView.reloadData()
            
        }catch{
            
            print((error as NSError).localizedDescription)
            
        }
        
    }
    
    //MARK: DELETE TEACHER
    func deleteThisTeacher(sender:UIButton, event: UIEvent){
        
        if let touch = event.touchesForView(sender)?.first  {
            let point = touch.locationInView(viewTeachertblView)
            print(point)
            if let indexPath = viewTeachertblView.indexPathForRowAtPoint(point) {
                
                searchAndDeleteThisUserNameFromDB(indexPath.row)
                teacherObj.removeAtIndex(indexPath.row)
                self.viewTeachertblView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
    }
    
    func searchAndDeleteThisUserNameFromDB(Index:Int){
        
        let context = appDelegate.managedObjectContext
        context.deleteObject(teacherObj[Index])
        
        do{
            
            try context.save()
            let alertController = UIAlertController(title: "Alert ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = "Deleted"
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }catch{
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = (error as NSError).localizedDescription
            self.presentViewController(alertController, animated: true, completion: nil)
            print(error)
            
        }
        
    }
    
    //MARK: LIST ALL DEPARTMENTS
    func ListAllDepartments(){
        
        let context = appDelegate.managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "Departments")
        deptObj = []
        do{
            
            let results = try context.executeFetchRequest(fetchReq)
            deptObj = results as! [Departments]
            self.viewTeachertblView.reloadData()
            
            
        }catch{
            
            print((error as NSError).localizedDescription)
            
        }
        
    }
    //MARK: DELETE DEPARTMENT
    func deleteThisDepartment(sender:UIButton, event: UIEvent){
        
        if let touch = event.touchesForView(sender)?.first  {
            let point = touch.locationInView(viewTeachertblView)
            if let indexPath = viewTeachertblView.indexPathForRowAtPoint(point) {
                
                searchAndDeleteThisDeptFromDB(indexPath.row)
                deptObj.removeAtIndex(indexPath.row)
                self.viewTeachertblView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
    }
    
    func searchAndDeleteThisDeptFromDB(Index:Int){
        
        let context = appDelegate.managedObjectContext
        context.deleteObject(deptObj[Index])
        
        do{
            
            try context.save()
            
            let alertController = UIAlertController(title: "Alert ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = "Deleted"
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }catch{
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = (error as NSError).localizedDescription
            self.presentViewController(alertController, animated: true, completion: nil)
            print(error)
            
        }
        
    }
    
}

//MARK: TABLE VIEW DATASOURCE AND DELEGATE METHODS
extension ViewController :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegment == 0{
            
            return teacherObj.count
            
        }else{
            
            return deptObj.count
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if selectedSegment == 0{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("teacherCell", forIndexPath: indexPath) as! TeacherTblVIewCell
            print(teacherObj[indexPath.row].teacher_name)
            cell.teacherName?.text = teacherObj[indexPath.row].teacher_name
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.deleteBtn.addTarget(self, action: "deleteThisTeacher:event:", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("departmentCell", forIndexPath: indexPath) as! DepartmentTblViewCell
            print(deptObj[indexPath.row].dept_name)
            cell.deptNameLbl?.text = deptObj[indexPath.row].dept_name
              cell.accessoryType = UITableViewCellAccessoryType.None
            cell.deptDeleteBtn.addTarget(self, action: "deleteThisDepartment:event:", forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("just pass the model object to other class and show the departments all")
        
        if selectedSegment == 0{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("teacherDetail") as! TeacherDetailVC
            vc.selectedTeacherObj = teacherObj[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    
}

