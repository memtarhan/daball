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

    var id: String { description + shortDescription + "\(value)" }
}

struct StandingModel: Identifiable {
    let rank: Int
    let name: String
    let logo: String
    let stats: [StatModel]

    var id: Int { rank }

    static let sample = [
        StandingModel(rank: 1,
                      name: "Liverpool",
                      logo: "https://cdn.ssref.net/req/202501061/tlogo/fb/mini.822bd0ba.png",
                      stats: [
                          StatModel(description: "Games", shortDescription: "MP", value: 19),
                          StatModel(description: "Wins", shortDescription: "W", value: 14),
                          StatModel(description: "Ties", shortDescription: "D", value: 4),
                          StatModel(description: "Losses", shortDescription: "L", value: 1),
                      ]),
        StandingModel(rank: 2,
                      name: "Arsenal",
                      logo: "https://cdn.ssref.net/req/202501061/tlogo/fb/mini.18bb7c10.png",
                      stats: [
                          StatModel(description: "Games", shortDescription: "MP", value: 20),
                          StatModel(description: "Wins", shortDescription: "W", value: 11),
                          StatModel(description: "Ties", shortDescription: "D", value: 7),
                          StatModel(description: "Losses", shortDescription: "L", value: 2),
                      ]),
    ]
}

@MainActor
class StandingsViewModel: ObservableObject, StandingsService {
    @Published var standings: [StandingModel] = []
    @Published var leagueTitle: String = ""
    @Published var loading: Bool = true

    func reset(competitionId: Int) {
        loading = true
        standings.removeAll()
        leagueTitle = ""

        Task { await handleStandings(competitionId: competitionId) }
    }

    func handleStandings(competitionId: Int) async {
        loading = true
        do {
            let response = try await getStandings(competitionId: competitionId)
            leagueTitle = response.leagueTitle

            standings = response.standings.map { standing in
                var stats =  standing.stats.map { stat in
                    StatModel(description: stat.description, shortDescription: stat.shortDescription, value: stat.value)
                }
                stats.insert(StatModel(description: "Points", shortDescription: "P", value: Double(standing.points)), at: 1)
                stats.append(contentsOf: standing.xgStats.map { stat in
                    StatModel(description: stat.description, shortDescription: stat.shortDescription, value: stat.value)
                })
                
                return StandingModel(rank: standing.rank, name: standing.name, logo: standing.logo, stats: stats)
            }

            loading = false

        } catch {
            print(error.localizedDescription)
            loading = true
        }
    }
}
