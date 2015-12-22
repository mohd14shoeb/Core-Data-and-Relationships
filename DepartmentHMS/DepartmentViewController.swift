//
//  TestViewController.swift
//  DepartmentHMS
//
//  Created by Bikram on 12/10/15.
//  Copyright © 2015 Esig. All rights reserved.
//

import UIKit
import CoreData

class DepartmentViewController: UIViewController {
    
    
    @IBOutlet weak var testTableView: UITableView!
    @IBOutlet weak var testNameTxtField: UITextField!

    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var deptObj = [TestEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        testTableView.delegate = self
        testTableView.dataSource = self
        ListAllDepartments()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    
    @IBAction func saveTestData(sender: AnyObject) {
        
        do{
            
            try validateAllTheTextFields(testNameTxtField.text!)
            
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
    func validateAllTheTextFields(deptName:String) throws{
        
        guard deptName != ""  else{
            
            throw FormError.Empty
            
        }
        
        guard deptName.characters.count > 3  else{
            
            throw FormError.LessThanFiveWords
            
        }
        
        addNewDepartment()
        
    }
    
    func addNewDepartment(){
        
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
        fetchReq.predicate = NSPredicate(format: "dept_name = %@", testNameTxtField.text!)
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
        let test = NSManagedObject(entity: entityDes!, insertIntoManagedObjectContext: context) as! TestEntity
        test.dept_name = testNameTxtField.text
        do{
            
            try  test.managedObjectContext?.save()
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default){(action) in
             self.ListAllDepartments()
            
            }
            alertController.addAction(defaultAction)
            alertController.message = "Department Name Added"
            self.presentViewController(alertController, animated: true,completion: nil)
            self.view.endEditing(true)
            testNameTxtField.text = ""
            
        }catch{
            
            let alertController = UIAlertController(title: "Hey ", message: "", preferredStyle: .Alert)
            let defaultAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            alertController.message = (error as NSError).localizedDescription
            self.presentViewController(alertController, animated: true, completion: nil)
            print(error)
            
        }
        
    }
    @IBAction func listTestName(sender: AnyObject) {
        
        ListAllDepartments()
        
    }
    
    func ListAllDepartments(){
        
        let context = appDelegate.managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "Departments")
        deptObj = []
        do{
            
            let results = try context.executeFetchRequest(fetchReq)
            deptObj = results as! [TestEntity]
            
            if deptObj.count > 0{
                
                self.testTableView.reloadData()
                
            }
            
        }catch{
            
            print((error as NSError).localizedDescription)
            
        }

    
    
    
    
    }

}
extension DepartmentViewController :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deptObj.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("teacherCell", forIndexPath: indexPath) as! TeacherTblVIewCell
        print(deptObj[indexPath.row].dept_name)
        cell.teacherName?.text = deptObj[indexPath.row].dept_name
        cell.deleteBtn.addTarget(self, action: "deleteThisDepartment:event:", forControlEvents: UIControlEvents.TouchUpInside)

        return cell
        
    }
    
    func deleteThisDepartment(sender:UIButton, event: UIEvent){
        
        if let touch = event.touchesForView(sender)?.first  {
            let point = touch.locationInView(testTableView)
            if let indexPath = testTableView.indexPathForRowAtPoint(point) {
                
                searchAndDeleteThisDeptFromDB(indexPath.row)
                deptObj.removeAtIndex(indexPath.row)
                self.testTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
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


