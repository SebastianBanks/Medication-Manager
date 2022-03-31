//
//  MoodSurvey+conveniance.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/29/22.
//

import CoreData

extension MoodSurvey {
    @discardableResult convenience init(mentalState: String, date: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.mentalState = mentalState
        self.date = date
    }
}
