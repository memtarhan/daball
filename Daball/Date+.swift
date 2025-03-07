//
//  Date+.swift
//  Daball
//
//  Created by Mehmet Tarhan on 4.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

extension Date {
    var asDisplayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy, HH:mm"

        return dateFormatter.string(from: self)
    }
}
