//
//  StatsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 10.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct PlayerStatModel: Identifiable {
    let player: String
    let team: String
    let value: Double

    var id: String { player + team + "\(value)" }
}

struct SectionedStatModel: Identifiable {
    let title: String
    let items: [PlayerStatModel]

    var id: String { title }
}

@MainActor
class StatsViewModel: ObservableObject, StatsService {
    @Published var loading: Bool = true
    @Published var stats: [SectionedStatModel] = []

    func reset(competitionId: Int) { }

    func handleStats(competitionId: Int) async {
        loading = true

        do {
            let response = try await getStats(competitionId: competitionId)

            stats = response.response.map { statsResponse in
                SectionedStatModel(title: statsResponse.displayName, items: statsResponse.items.map { statResponse in
                    PlayerStatModel(player: statResponse.player, team: statResponse.team, value: statResponse.value)
                })
            }

            loading = false

        } catch {
            print(error.localizedDescription)
            loading = false
        }
    }
}
