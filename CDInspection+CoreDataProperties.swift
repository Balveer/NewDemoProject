//
//  CDInspection+CoreDataProperties.swift
//  NewDemoProject
//
//  Created by Apple on 26/07/24.
//
//

import Foundation
import CoreData


extension CDInspection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDInspection> {
        return NSFetchRequest<CDInspection>(entityName: "CDInspection")
    }

    @NSManaged public var id: String?
    @NSManaged public var state: String?

}

extension CDInspection : Identifiable {

}
