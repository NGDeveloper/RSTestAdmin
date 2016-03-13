//
//  Property+CoreDataProperties.swift
//  RealtyShares Admin
//
//  Created by Nikolay Galkin on 10.03.16.
//  Copyright © 2016 RealtyShares. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Property {

    @NSManaged var pid: String?
    @NSManaged var message: String?
    @NSManaged var title: String?
    @NSManaged var url: String?

}
