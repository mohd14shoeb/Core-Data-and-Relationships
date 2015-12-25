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
    var teacherObj = [NSManagedObject]()
    
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
 
    //MARK: LIST ALL TEACHERS
    func listAllTeachers(){
        
        let context = appDelegate.managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "Teachers")
        teacherObj = []
        do{
            
            let results = try context.executeFetchRequest(fetchReq)
            teacherObj = results as! [NSManagedObject]
            if  teacherObj.count > 0 {
                
                viewTeachertblView.reloadData()
                
            }
            
        }catch{
            
            print((error as NSError).localizedDescription)
            
        }
        
    }
    
    //MARK: DELETE TEACHER
    func deleteThisTeacher(sender:UIButton, event: UIEvent){
        
        if let touch = event.touchesForView(sender)?.first  {
            let point = touch.locationInView(viewTeachertblView)
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

    
}
 //MARK: Table View datasource and delegate methods
extension ViewController :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teacherObj.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("teacherCell", forIndexPath: indexPath) as! TeacherTblVIewCell
        print(teacherObj[indexPath.row].valueForKey("teacher_name") as? String)
        cell.teacherName?.text = teacherObj[indexPath.row].valueForKey("teacher_name") as? String
        cell.deleteBtn.addTarget(self, action: "deleteThisTeacher:event:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("just pass the model object to other class and show the departments all")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("teacherDetail") as! TeacherDetailVC
        vc.selectedTeacherObj = teacherObj[indexPath.row]
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
}

