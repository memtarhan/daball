//
//  StandingsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import BallKit
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

@MainActor
class StandingsViewModel: ObservableObject, StandingsService {
    @Published var leagueTitle: String = ""
    @Published var loading: Bool = true
    @Published var hasOtherPhases: Bool = false
    @Published var knockoutPhase: [KnockoutPhaseModel] = []

    @Published var standings: [StandingsData] = []

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
                        StatsData(
                            description: stat.description,
                            shortDescription: stat.shortDescription,
                            value: stat.value,
                            tooltip: leagueStandings.statTypes?.first(where: { $0.shortDescription == stat.shortDescription })?.description
                        )
                    }

                    stats
                        .append(
                            contentsOf: standing.xgStats.map { stat in
                                StatsData(
                                    description: stat.description,
                                    shortDescription: stat.shortDescription,
                                    value: stat.value,
                                    tooltip: leagueStandings.statTypes?.first(where: { $0.shortDescription == stat.shortDescription })?.description
                                )
                            })

                    return StandingsData(
                        rank: standing.rank,
                        id: standing.teamId,
                        name: standing.name,
                        logo: standing.logo,
                        stats: stats,
                        lastFiveGames: standing.lastFiveGames.map { LastGameData(id: $0.id, status: GameStatus(withLetter: $0.status.rawValue)) }
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
