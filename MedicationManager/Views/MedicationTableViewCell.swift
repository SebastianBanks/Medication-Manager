//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/29/22.
//

import UIKit

protocol MedicationTableViewCellDelegate: class {
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool)
}

class MedicationTableViewCell: UITableViewCell {
    
    weak var delegate: MedicationTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenButton: UIButton!

    
    private var medication: Medication?
    private var wasTakenToday: Bool = false
    
    @IBAction func wasTakenButtonTapped(_ sender: UIButton) {
        guard let medication = medication else { return }
        wasTakenToday.toggle()
        delegate?.medicationWasTakenButtonTapped(medication: medication, wasTaken: wasTakenToday)
    }
    
    func config(with medication: Medication) {
        self.medication = medication
        wasTakenToday = medication.wasTakenToday()
        nameLabel.text = medication.name
        timeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date())
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        wasTakenButton.setImage(image, for: .normal)
    }
    

}
