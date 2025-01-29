//
//  TabItem.swift
//  Daball
//
//  Created by Mehmet Tarhan on 29.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

enum TabItem: Int, CaseIterable {
    case current = 0
    case standings
    case fixtures
    case stats

    var title: String {
        switch self {
        case .current:
            return "Current"
        case .standings:
            return "Standings"
        case .fixtures:
            return "Fixtures"
        case .stats:
            return "Stats"
        }
    }

    var iconName: String {
        switch self {
        case .current:
            return "timelapse"
        case .standings:
            return "table"
        case .fixtures:
            return "calendar"
        case .stats:
            return "chart.line.uptrend.xyaxis"
        }
    }
}
