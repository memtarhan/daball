//
//  StandingsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct KnockoutPhaseTeamModel: Identifiable {
    let name: String
    let id: String
    let logo: String
}

struct KnockoutPhaseMatchModel: Identifiable {
    let homeTeam: String
    let awayTeam: String
    let time: String
    let date: String

    var id: String { homeTeam + awayTeam }
}

struct KnockoutPhaseModel: Identifiable {
    let teams: [KnockoutPhaseTeamModel]
    let matches: [KnockoutPhaseMatchModel]
    let notes: String
    var id: String { teams.description }

    static let sample = KnockoutPhaseModel(teams: [KnockoutPhaseTeamModel(name: "Bayern Munich", id: "054efa67", logo: "https://res.cloudinary.com/htok5sdtn/image/upload/v1/teams/logos/054efa67"),
                                                   KnockoutPhaseTeamModel(name: "Celtic", id: "b81aa4fa", logo: "https://res.cloudinary.com/htok5sdtn/image/upload/v1/teams/logos/b81aa4fa")],
                                           matches: [KnockoutPhaseMatchModel(homeTeam: "Celtic", awayTeam: "Bayern Munich", time: "20:00", date: "Feb 12"),
                                                     KnockoutPhaseMatchModel(homeTeam: "Bayern Munich", awayTeam: "Celtic", time: "21:00", date: "Feb 18")],
                                           notes: "Results are the aggregate results over two legs.")
}

struct StatModel: Identifiable {
    let description: String
    let shortDescription: String
    let value: Double
    var tooltip: String? = nil

    var id: String {
        description + shortDescription + "\(value)"
    }
}

struct LastGameModel: Identifiable {
    var id: String
    var status: String

    static let sample = LastGameModel(id: "ac04a5d2", status: "L")
}

struct StandingModel: Identifiable {
    let rank: Int
    let id: String
    let name: String
    let logo: String
    let stats: [StatModel]
    let lastFiveGames: [LastGameModel]

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
            ],
            lastFiveGames: [LastGameModel.sample]
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
            ],
            lastFiveGames: [LastGameModel.sample]
        ),
    ]
}

@MainActor
class StandingsViewModel: ObservableObject, StandingsService {
    @Published var standings: [StandingModel] = []
    @Published var leagueTitle: String = ""
    @Published var loading: Bool = true
    @Published var hasOtherPhases: Bool = false
    @Published var knockoutPhase: [KnockoutPhaseModel] = []

    func reset(competitionId: Int) {
        loading = true
        hasOtherPhases = false
        standings.removeAll()
        leagueTitle = ""

        Task {
            await handleStandings(competitionId: competitionId)
        }
    }

    func handleStandings(competitionId: Int) async {
        loading = true
        do {
            let response = try await getStandings(competitionId: competitionId)
            if let phase = response.phases.first(where: { $0.type == .knockout }) {
                hasOtherPhases = true
                knockoutPhase = phase.matches?.map { match in
                    KnockoutPhaseModel(teams: match.teams.map { team in
                        KnockoutPhaseTeamModel(name: team.name, id: team.id, logo: team.logo)
                    }, matches: match.matches.map { singleMatch in
                        KnockoutPhaseMatchModel(homeTeam: singleMatch.homeTeam, awayTeam: singleMatch.awayTeam, time: singleMatch.time, date: singleMatch.date)
                    }, notes: match.notes)
                } ?? []
            }
            guard let leagueStandings = response.phases.first(where: { $0.type == .league }) else {
                // TODO: Display error view
                return
            }

            leagueTitle = leagueStandings.title

            standings = leagueStandings.standings?
                .map { standing in
                    var stats = standing.stats.map { stat in
                        StatModel(
                            description: stat.description,
                            shortDescription: stat.shortDescription,
                            value: stat.value,
                            tooltip: leagueStandings.statTypes?.first(where: { $0.shortDescription == stat.shortDescription })?.description
                        )
                    }

                    stats
                        .append(
                            contentsOf: standing.xgStats.map { stat in
                                StatModel(
                                    description: stat.description,
                                    shortDescription: stat.shortDescription,
                                    value: stat.value,
                                    tooltip: leagueStandings.statTypes?.first(where: { $0.shortDescription == stat.shortDescription })?.description
                                )
                            })

                    return StandingModel(
                        rank: standing.rank,
                        id: standing.teamId,
                        name: standing.name,
                        logo: standing.logo,
                        stats: stats,
                        lastFiveGames: standing.lastFiveGames.map { LastGameModel(id: $0.id, status: $0.status.rawValue) }
                    )
                } ?? []

            loading = false

        } catch {
            print(
                error.localizedDescription
            )
            loading = false
        }
    }
}
