//
//  DateFormatter.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/29/22.
//

import Foundation

extension DateFormatter {
    static let medicationTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
