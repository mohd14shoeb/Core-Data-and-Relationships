//
//  ViewController.swift
//  DepartmentHMS
//
//  Created by Bikram on 12/10/15.
//  Copyright © 2015 Esig. All rights reserved.
//

import UIKit
import CoreData

enum FormError:ErrorType{
    
    case Empty
    case LessThanFiveWords
    case TeacherNameExists
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var addStdnBtn: UIButton!
    @IBOutlet weak var viewTeachertblView: UITableView!
    @IBOutlet weak var teachNameTxtField: UITextField!
    @IBOutlet weak var teacherAddTxtField: UITextField!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var teacherObj = [NSManagedObject]()
    
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewTeachertblView.delegate = self
        viewTeachertblView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ACTIONS
    @IBAction func addNewTeacher(sender: AnyObject) {
        
        do{
            
            try validateAllTheTextFields(teachNameTxtField.text!, teachAddress: teacherAddTxtField.text!)
            
        }catch FormError.Empty{
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = "Name and Adddress cannot be empty"
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }catch FormError.LessThanFiveWords{
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = "Name & Address must be at least five words"
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
    
    @IBAction func clearTextFields(sender: AnyObject) {
        
        teachNameTxtField.text = ""
        teacherAddTxtField.text = ""
        self.view.endEditing(true)
        
    }
    
    @IBAction func viewAllTeacher(sender: AnyObject) {
        
        listAllTeachers()
        if  teacherObj.count > 0 {
            
            viewTeachertblView.reloadData()
            
        }
        
    }
    
    
    //TODO: VIEW ALL TEACHERS
    
    func listAllTeachers(){
        
        let context = appDelegate.managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "Teachers")
        teacherObj = []
        do{
            
            let results = try context.executeFetchRequest(fetchReq)
            teacherObj = results as! [NSManagedObject]
            
        }catch{
            
            print((error as NSError).localizedDescription)
            
        }
        
    }
    
    //MARK: ADD TEACHER TO DATABASE
    func addNewTeacher(){
        
        do{
            
            try checkIfTeacherNameExistsOrNot()
            
        }catch FormError.TeacherNameExists{
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = "Teacher Name already exists"
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }catch{
            
            print("error unexpected")
        }
        
    }
    
    func saveTeacherName(){
        
        let context = appDelegate.managedObjectContext
        let entityDes = NSEntityDescription.entityForName("Teachers", inManagedObjectContext: context)
        let newTeacher = NSManagedObject(entity: entityDes!, insertIntoManagedObjectContext: context)
        newTeacher.setValue(teachNameTxtField.text, forKey: "teacher_name")
        newTeacher.setValue(teacherAddTxtField.text, forKey: "teacher_address")
        
        do{
            
            try  newTeacher.managedObjectContext?.save()
            teachNameTxtField.text = ""
            teacherAddTxtField.text = ""
            self.view.endEditing(true)
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = "Teacher Name Added"
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
    
    func checkIfTeacherNameExistsOrNot() throws{
        
        var error:NSError?
        let context = appDelegate.managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "Teachers")
        fetchReq.predicate = NSPredicate(format: "teacher_name = %@", teachNameTxtField.text!)
        fetchReq.fetchLimit = 1
        let count = context.countForFetchRequest(fetchReq, error: &error)
        guard error == nil else{
            
            return
            
        }
        
        guard count < 1 else{
            
            throw FormError.TeacherNameExists
            
        }
        
        saveTeacherName()
        
    }
    
    func validateAllTheTextFields(teachName:String,teachAddress:String) throws{
        
        guard teachName != "" || teachAddress != "" else{
            
            throw FormError.Empty
            
        }
        
        guard teachName.characters.count > 5 || teachAddress.characters.count > 5  else{
            
            throw FormError.LessThanFiveWords
            
        }
        
        addNewTeacher()
        
    }
    
}

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

