//
//  CurrentViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 12.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct LeagueLeaderSimpleModel: Identifiable {
    let description: String
    let players: [String]
    let value: Double

    var id: String { description }
}

struct StatSimpleModel: Identifiable {
    let shortDescription: String
    let value: String

    var id: String { shortDescription + value }
}

struct StandingSimpleModel: Identifiable {
    let team: String
    let rank: String
    let stats: [StatSimpleModel]

    var id: String { team + rank }
}

struct LeagueModel: Identifiable {
    let title: String
    let country: String
    let standings: [StandingSimpleModel]
    let leaders: [LeagueLeaderSimpleModel]

    var id: String { title + country }
}

@MainActor
class CurrentViewModel: ObservableObject, CurrentService {
    @Published var loading: Bool = true
    @Published var leagues: [LeagueModel] = []
    @Published var expandedLeagues: [LeagueModel] = []

    func handleCurrent() async {
        loading = true
        let response = try! await getCurrent()

        leagues = response.response.map { current in
            LeagueModel(title: current.title,
                        country: current.country,
                        standings: current.standings.map { standing in
                            StandingSimpleModel(team: standing.team,
                                                rank: standing.rank,
                                                stats: standing.stats.map { stat in
                                                    StatSimpleModel(shortDescription: stat.shortDescription,
                                                                    value: stat.value)
                                                })
                        }, leaders: current.leaders.map { leader in
                            LeagueLeaderSimpleModel(description: leader.description,
                                                    players: leader.players,
                                                    value: leader.value)
                        })
        }

        expandedLeagues.removeAll()
        if let first = leagues.first {
            expandedLeagues.append(first)
        }

        loading = false
    }
}
