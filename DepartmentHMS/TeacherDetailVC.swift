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
    var deptObj = [TestEntity]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var deptTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(selectedTeacherObj!.valueForKey("teacher_name") as? String)
        self.title =  selectedTeacherObj!.valueForKey("teacher_name") as? String
        deptTableView.dataSource = self
        listAllDepartments()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func listAllDepartments(){
        
        let context = appDelegate.managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "Departments")
        deptObj = []
        do{
            
            let results = try context.executeFetchRequest(fetchReq)
            deptObj = results as! [TestEntity]
            
            if deptObj.count > 0{
                
                self.deptTableView.reloadData()
                
            }
            
        }catch{
            
            print((error as NSError).localizedDescription)
            
        }
          
    }

    
    
    @IBAction func cancelBtn(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
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
    
    func addTeacherToThisDepartment(sender:UIButton){
        //mark as added
    
    
        
    
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



