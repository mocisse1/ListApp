//
//  List+CoreDataProperties.swift
//  ListApp
//
//  Created by Mamoudou Cisse on 3/8/23.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?

}

extension List : Identifiable {

}
