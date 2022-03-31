//
//  MoodSurveyViewController.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/29/22.
//

import UIKit

protocol MoodSurveyViewControllerDelegate: class {
    func moodButtonTapped(with emoji: String)
}

class MoodSurveyViewController: UIViewController {
    
    weak var delegate: MoodSurveyViewControllerDelegate?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reminderFired),
            name: NSNotification.Name(rawValue: Strings.medicationReminderRecieved),
            object: nil
        )
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emojiTapped(_ sender: UIButton) {
        guard let emoji = sender.titleLabel?.text else { return }
        delegate?.moodButtonTapped(with: emoji)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func reminderFired() {
        print("\(#file) recieved the MEMO!")
        
        view.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemCyan
        }
    }

}
