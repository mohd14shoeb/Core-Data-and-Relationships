//
//  Teachers+CoreDataProperties.swift
//  DepartmentHMS
//
//  Created by Bikram on 12/10/15.
//  Copyright © 2015 Esig. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Teachers {

    @NSManaged var teacher_name: String?
    @NSManaged var teacher_address: String?

}
