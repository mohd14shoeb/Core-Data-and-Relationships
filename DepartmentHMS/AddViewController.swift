//
//  AddViewController.swift
//  DepartmentHMS
//
//  Created by Anish on 12/25/15.
//  Copyright © 2015 Esig. All rights reserved.
//

import UIKit
import CoreData

enum DeptOrTeacherType{
    
    case Department
    case Teacher
    
}
enum FormError:ErrorType{
    
    case Empty
    case LessThanFiveWords
    case TeacherNameExists
    
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var teachNameTxtField: UITextField!
    @IBOutlet weak var teacherAddressTxtField: UITextField!
    var deptOrTeacher : DeptOrTeacherType?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //MARK:-VIEW LIFE CYCLE
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        changePlaceHolderAccordingToEnum()
        
    }
    
    func changePlaceHolderAccordingToEnum(){
        
        guard deptOrTeacher != nil else{
            
            return
            
        }
        
        switch deptOrTeacher!{
            
        case .Teacher:
            
            print("already shown placeholder for teacher in storyboard")
            
        case .Department:
            
            teachNameTxtField.placeholder = "Department Name"
            teacherAddressTxtField.hidden = true
            
        }
        
    }
    //MARK:-IBACTIONS
    @IBAction func saveBtn(sender: AnyObject) {
        
        guard deptOrTeacher != nil else{
            
            return
            
        }
        
        switch deptOrTeacher!{
            
        case .Teacher:
            
            addNewTeacher()
            
        case .Department:
            
            addNewDepartment()
            
        }
        
    }
    
    @IBAction func clearBtn(sender: AnyObject) {
        
        teachNameTxtField.text = ""
        teacherAddressTxtField.text = ""
        self.view.endEditing(true)
        
    }
    
    //MARK:-ADD NEW TEACHER
    func addNewTeacher(){
        do{
            
            try validateAllTheTextFields(teachNameTxtField.text!, teachAddress: teacherAddressTxtField.text!)
            
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
    func validateAllTheTextFields(teachName:String,teachAddress:String) throws{
        
        guard teachName != "" || teachAddress != "" else{
            
            throw FormError.Empty
            
        }
        
        guard teachName.characters.count > 5 || teachAddress.characters.count > 5  else{
            
            throw FormError.LessThanFiveWords
            
        }
        
        addTeacher()
        
    }
    
    func addTeacher(){
        
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
    func saveTeacherName(){
        
        let context = appDelegate.managedObjectContext
        let entityDes = NSEntityDescription.entityForName("Teachers", inManagedObjectContext: context)
        let newTeacher = NSManagedObject(entity: entityDes!, insertIntoManagedObjectContext: context) as! Teachers
        newTeacher.teacher_name = teachNameTxtField.text
        newTeacher.teacher_address = teacherAddressTxtField.text
              
        do{
            
            try  newTeacher.managedObjectContext?.save()
            teachNameTxtField.text = ""
            teacherAddressTxtField.text = ""
            self.view.endEditing(true)
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default){(action) in
                
                
                
            }
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
    //MARK:-ADD NEW DEPARTMENT
    
    func addNewDepartment(){
        
        do{
            
            try validateDepartmentNameTextField(teachNameTxtField.text!)
            
        }catch FormError.Empty{
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = "Dept Name cannot be empty"
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }catch FormError.LessThanFiveWords{
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = "Dept name must be at least three words"
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
    func validateDepartmentNameTextField(deptName:String) throws{
        
        guard deptName != ""  else{
            
            throw FormError.Empty
            
        }
        
        guard deptName.characters.count > 3  else{
            
            throw FormError.LessThanFiveWords
            
        }
        
        addDepartment()
        
    }
    func addDepartment(){
        
        do{
            
            try checkIfDepartmentNameExistsOrNot()
            
        }catch FormError.TeacherNameExists{
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = "Department Name already exists"
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }catch{
            
            print("error unexpected")
        }
        
    }
    func checkIfDepartmentNameExistsOrNot() throws{
        
        var error:NSError?
        let context = appDelegate.managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "Departments")
        fetchReq.predicate = NSPredicate(format: "dept_name = %@", teachNameTxtField.text!)
        fetchReq.fetchLimit = 1
        let count = context.countForFetchRequest(fetchReq, error: &error)
        guard error == nil else{
            
            return
            
        }
        
        guard count < 1 else{
            
            throw FormError.TeacherNameExists
            
        }
        
        saveDepartmentName()
        
    }
    func saveDepartmentName(){
        
        let context = appDelegate.managedObjectContext
        let entityDes = NSEntityDescription.entityForName("Departments", inManagedObjectContext: context)
        let departMent = NSManagedObject(entity: entityDes!, insertIntoManagedObjectContext: context) as! Departments
        departMent.dept_name = teachNameTxtField.text
        do{
            
            try  departMent.managedObjectContext?.save()
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default){(action) in
                
                
            }
            alertController.addAction(defaultAction)
            alertController.message = "Department Name Added"
            self.presentViewController(alertController, animated: true,completion: nil)
            self.view.endEditing(true)
            teachNameTxtField.text = ""
            
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
