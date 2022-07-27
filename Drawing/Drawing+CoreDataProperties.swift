//
//  Drawing+CoreDataProperties.swift
//  Drawing
//
//  Created by Gabriel Oliveira on 27/07/22.
//
//

import Foundation
import CoreData


extension Drawing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drawing> {
        return NSFetchRequest<Drawing>(entityName: "Drawing")
    }

    @NSManaged public var canvasData: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

    public var wrappedTitle: String {
        title ?? "Unknown Title"
    }
    public var wrappedId: UUID {
        id ?? UUID()
    }
}

extension Drawing : Identifiable {

}
