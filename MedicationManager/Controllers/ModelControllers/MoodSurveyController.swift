//
//  MoodSurveyController.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/29/22.
//

import CoreData

class MoodSurveyController {
    
    static let shared = MoodSurveyController()
    
    private lazy var fetchRequest: NSFetchRequest<MoodSurvey> = {
        let request = NSFetchRequest<MoodSurvey>(entityName: Strings.moodSurveyEntityName)
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let endOfToday = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday) ?? Date()
        let afterPredicate = NSPredicate(format: "date > %@", startOfToday as NSDate)
        let beforePredicate = NSPredicate(format: "date < %@", endOfToday as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [afterPredicate, beforePredicate])
        return request
    }()
    
    private init() {}

    var todaysMoodSurvey: MoodSurvey?
    
    private func createMoodSurvey(mentalState: String) {
        let moodSurvey = MoodSurvey(mentalState: mentalState, date: Date())
        todaysMoodSurvey = moodSurvey
        CoreDataStack.saveContext()
    }
    
    func fetchTodaysSurvey() -> MoodSurvey? {
        guard let todaysMoodSurvey = try? CoreDataStack.context.fetch(fetchRequest).first else { return nil }
        
        self.todaysMoodSurvey = todaysMoodSurvey
        return self.todaysMoodSurvey
    }
    
    private func update(mentalState: String) {
        guard let todaysMoodSurvey = todaysMoodSurvey else { return }

        todaysMoodSurvey.mentalState = mentalState
        CoreDataStack.saveContext()
    }
    
    func didTapMoodEmoji(_ emoji: String) {
        if todaysMoodSurvey != nil {
            update(mentalState: emoji)
        } else {
            createMoodSurvey(mentalState: emoji)
        }
    }
}
