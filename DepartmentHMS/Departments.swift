//
//  Departments.swift
//  DepartmentHMS
//
//  Created by Anish on 12/25/15.
//  Copyright © 2015 Esig. All rights reserved.
//

import Foundation
import CoreData

class Departments: NSManagedObject {
    
    override func prepareForDeletion() {
        
        for tea in self.teachers!{
            if let temp = tea as? Teachers{
                if temp.departments?.count == 1{
                    self.managedObjectContext?.deleteObject(temp)
                }else{
                    print("this teacher is assigned to another department also")
                }
            }
            
        }
        
    }
    
}