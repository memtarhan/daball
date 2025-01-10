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
    let rank: Int?

    var id: String { player + team + "\(value)" }
}

struct SectionedStatModel: Identifiable, Equatable, Hashable {
    let title: String
    let id: String
    let items: [PlayerStatModel]
    
    static func == (lhs: SectionedStatModel, rhs: SectionedStatModel) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@MainActor
class StatsViewModel: ObservableObject, StatsService {
    @Published var loading: Bool = true
    @Published var stats: [SectionedStatModel] = []
    @Published var selectedSection: SectionedStatModel? = nil

    func reset(competitionId: Int) { }

    func handleStats(competitionId: Int) async {
        loading = true

        do {
            let response = try await getStats(competitionId: competitionId)

            stats = response.response.map { statsResponse in
                SectionedStatModel(
                    title: statsResponse.title,
                    id: statsResponse.id,
                    items: statsResponse.items.map { statResponse in
                        PlayerStatModel(
                            player: statResponse.player,
                            team: statResponse.team,
                            value: statResponse.value,
                            rank: statResponse.rank
                        )
                    })
            }
            
            selectedSection = stats.first
            
            loading = false

        } catch {
            print(error.localizedDescription)
            loading = false
        }
    }
}
