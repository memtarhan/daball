//
//  FootballStatsModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 26.03.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation
import Networkable

struct FootballStats: Identifiable {
    let title: String
    let id: String
    let items: [FootballStatsItem]
}

struct FootballStatsItem: Identifiable {
    let player: String
    let team: String
    let teamLogo: String?
    let rank: Int?
    let value: Double

    var id: String { player + team }
}

@Observable
final class FootballStatsModel: ObservableObject {
    var stats: [FootballStats] = []
    var title = "Stats"

    private let service: FootballStatsService

    init(service: FootballStatsService) {
        self.service = service
    }

    func fetch() async {
        do {
            let response = try await service.fetchStats()
            stats = response.stats.map { statResponse in
                FootballStats(title: statResponse.title, id: statResponse.id, items: statResponse.items.map { item in
                    FootballStatsItem(player: item.player,
                                      team: item.team,
                                      teamLogo: item.teamLogo,
                                      rank: item.rank,
                                      value: item.value)
                })
            }

        } catch {
            // TODO: Handle error
            print(error)
        }
    }
}
