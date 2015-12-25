//
//  Departments+CoreDataProperties.swift
//  DepartmentHMS
//
//  Created by Anish on 12/25/15.
//  Copyright © 2015 Esig. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Departments {

    @NSManaged var dept_name: String?
    @NSManaged var teachers: NSSet?

}
