//
//  StandingsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct StatModel: Identifiable {
    let description: String
    let shortDescription: String
    let value: Double
    var tooltip: String? = nil

    var id: String {
        description + shortDescription + "\(value)"
    }
}

struct StandingModel: Identifiable {
    let rank: Int
    let id: String
    let name: String
    let logo: String
    let stats: [StatModel]

    static let sample = [
        StandingModel(
            rank: 1,
            id: "ab",
            name: "Liverpool",
            logo: "https://cdn.ssref.net/req/202501061/tlogo/fb/mini.822bd0ba.png",
            stats: [
                StatModel(
                    description: "Games",
                    shortDescription: "MP",
                    value: 19
                ),
                StatModel(
                    description: "Wins",
                    shortDescription: "W",
                    value: 14
                ),
                StatModel(
                    description: "Ties",
                    shortDescription: "D",
                    value: 4
                ),
                StatModel(
                    description: "Losses",
                    shortDescription: "L",
                    value: 1
                ),
            ]
        ),
        StandingModel(
            rank: 2,
            id: "ac",
            name: "Arsenal",
            logo: "https://cdn.ssref.net/req/202501061/tlogo/fb/mini.18bb7c10.png",
            stats: [
                StatModel(
                    description: "Games",
                    shortDescription: "MP",
                    value: 20
                ),
                StatModel(
                    description: "Wins",
                    shortDescription: "W",
                    value: 11
                ),
                StatModel(
                    description: "Ties",
                    shortDescription: "D",
                    value: 7
                ),
                StatModel(
                    description: "Losses",
                    shortDescription: "L",
                    value: 2
                ),
            ]
        ),
    ]
}

@MainActor
class StandingsViewModel: ObservableObject, StandingsService {
    @Published var standings: [StandingModel] = []
    @Published var leagueTitle: String = ""
    @Published var loading: Bool = true

    func reset(
        competitionId: Int
    ) {
        loading = true
        standings
            .removeAll()
        leagueTitle = ""

        Task {
            await handleStandings(
                competitionId: competitionId
            )
        }
    }

    func handleStandings(
        competitionId: Int
    ) async {
        loading = true
        do {
            let response = try await getStandings(
                competitionId: competitionId
            )
            leagueTitle = response.leagueTitle

            standings = response.standings
                .map { standing in
                    var stats = standing.stats.map { stat in
                        StatModel(
                            description: stat.description,
                            shortDescription: stat.shortDescription,
                            value: stat.value,
                            tooltip: response.statTypes.first(where: { $0.shortDescription == stat.shortDescription })?.description
                        )
                    }

                    stats
                        .append(
                            contentsOf: standing.xgStats.map { stat in
                                StatModel(
                                    description: stat.description,
                                    shortDescription: stat.shortDescription,
                                    value: stat.value,
                                    tooltip: response.statTypes.first(where: { $0.shortDescription == stat.shortDescription })?.description
                                )
                            })

                    return StandingModel(
                        rank: standing.rank,
                        id: standing.teamId,
                        name: standing.name,
                        logo: standing.logo,
                        stats: stats
                    )
                }

            loading = false

        } catch {
            print(
                error.localizedDescription
            )
            loading = false
        }
    }
}
