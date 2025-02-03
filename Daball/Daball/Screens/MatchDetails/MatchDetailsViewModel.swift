//
//  MatchDetailsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 3.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct MatchDataPointModel: Identifiable {
    let description: String
    let value: String

    var id: String { description + value }
}

struct MatchTeamModel {
    let name: String
    let logo: String
    let currentStats: String
    let score: String
    let scoreXg: String?
    let dataPoints: [MatchDataPointModel]
}

struct MatchDetailsModel {
    let date: String
    let details: [MatchDataPointModel]
}

@MainActor
class MatchDetailsViewModel: ObservableObject, MatchService {
    @Published var loading: Bool = true
    @Published var title: String = ""
    @Published var matchTeams: [MatchTeamModel] = []
    @Published var details: MatchDetailsModel?

    func handleMatch(matchId: String) async {
        do {
            let response = try await getMatch(matchId: matchId)
            title = response.title

            matchTeams = response.teams.map { team in
                MatchTeamModel(name: team.name,
                               logo: team.logo,
                               currentStats: team.currentStats,
                               score: team.score,
                               scoreXg: team.scoreXg,
                               dataPoints: team.dataPoints.map { MatchDataPointModel(description: $0.description, value: $0.value) })
            }

            details = MatchDetailsModel(date: Date(timeIntervalSince1970: response.date.epoch).asDisplayDate,
                                        details: response.details.map { MatchDataPointModel(description: $0.description, value: $0.value) })

            loading = false
        } catch {
            print(error.localizedDescription)
            loading = false
        }
    }
}
