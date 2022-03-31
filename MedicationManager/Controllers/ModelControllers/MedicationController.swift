//
//  MedicationController.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/29/22.
//

import Foundation
import CoreData

class MedicationController {
    
    static let shared = MedicationController()
    let nofificationSchedular = NotificationSchedular()
    
    private init() {}
    
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: Strings.medicationEntityName)
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    var sections: [[Medication]] { [notTakenMeds, takenMeds] }
    private var notTakenMeds: [Medication] = []
    private var takenMeds: [Medication] = []
    
    // CRUD
    
    func create(name: String, date: Date) {
        let medication = Medication(name: name, timeOfDay: date)
        notTakenMeds.append(medication)
        CoreDataStack.saveContext()
        
        nofificationSchedular.scheduleNotif(for: medication)
    }
    
    func fetchMedication() {
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        takenMeds = medications.filter { $0.wasTakenToday() }
        notTakenMeds = medications.filter { !$0.wasTakenToday() }
    }
    
    func updateMedication(medication: Medication, name: String, timeOfDay: Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
        
        nofificationSchedular.cancelNotif(for: medication)
        nofificationSchedular.scheduleNotif(for: medication)
    }
    
    func medicationTaken(medication: Medication, wasTaken: Bool) {
        if wasTaken {
            TakenDate(date: Date(), medication: medication)
            if let index = notTakenMeds.firstIndex(of: medication) {
                notTakenMeds.remove(at: index)
                takenMeds.append(medication)
            }
        } else {
            let mutableTakenDates = medication.mutableSetValue(forKey: "takenDates")
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: { takenDate in
                guard let date = takenDate.date else { return false }
                
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }) {
                mutableTakenDates.remove(takenDate)
                if let index = takenMeds.firstIndex(of: medication) {
                    takenMeds.remove(at: index)
                    notTakenMeds.append(medication)
                }
            }
        }
        CoreDataStack.saveContext()
    }
    
    func markMedicationTaken(withID: String) {
        guard let medication = notTakenMeds.first(where: {$0.id == withID}) else { return }
        
        medicationTaken(medication: medication, wasTaken: true)
        CoreDataStack.saveContext()
    }
    
    func deleteMedication(_ medication: Medication) {
        if let index = notTakenMeds.firstIndex(of: medication) {
            notTakenMeds.remove(at: index)
        } else if let index = takenMeds.firstIndex(of: medication) {
            takenMeds.remove(at: index)
        }
        
        CoreDataStack.context.delete(medication)
        CoreDataStack.saveContext()
        nofificationSchedular.cancelNotif(for: medication)
    }
    
}
