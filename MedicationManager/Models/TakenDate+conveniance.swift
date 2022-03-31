//
//  TakenDate+conveniance.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/29/22.
//

import CoreData

extension TakenDate {
    @discardableResult convenience init(date: Date, medication: Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.medication = medication
    }
}
