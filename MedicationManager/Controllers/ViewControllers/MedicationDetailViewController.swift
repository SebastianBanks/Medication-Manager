//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/29/22.
//

import UIKit

class MedicationDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var medication: Medication?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let medication = medication, let timeOfDay = medication.timeOfDay {
            title = medication.name
            nameTextField.text = medication.name
            datePicker.date = timeOfDay
        } else {
            title = "Add Medication"
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reminderFired),
            name: NSNotification.Name(rawValue: Strings.medicationReminderRecieved),
            object: nil
        )
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text,
              !name.isEmpty
        else { return }
        
        let date = datePicker.date
        
        if let medication = medication {
            MedicationController.shared.updateMedication(medication: medication, name: name, timeOfDay: date)
        } else {
            MedicationController.shared.create(name: name, date: date)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func reminderFired() {
        print("\(#file) recieved the MEMO!")
        view.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemCyan
        }
    }
    
    

}
