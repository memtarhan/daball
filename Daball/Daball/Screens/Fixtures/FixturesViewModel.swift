//
//  FixturesViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct WeekModel: Identifiable, Equatable {
    let number: Int
    let description: String

    var id: Int { number }
}

struct ScoreModel: Identifiable {
    let homeTeam: String
    let awayTeam: String
    let score: String
    let date: String

    var id: String { homeTeam + awayTeam + date }
}

@MainActor
class FixturesViewModel: ObservableObject, FixturesService {
    @Published var weeks: [WeekModel] = []
    @Published var selectedWeek: WeekModel? = nil
    @Published var scores: [ScoreModel] = []
    @Published var leagueTitle: String = ""
    @Published var loading: Bool = true

    private var response: FixturesResponse?

    func reset(competitionId: Int) {
        loading = true
        weeks.removeAll()
        selectedWeek = nil
        leagueTitle = ""

        Task { await handleFixtures(competitionId: competitionId) }
    }

    func handleSelectedWeeksFixture() {
        if let gameWeek = selectedWeek?.number,
           let fixture = response?.fixtures[gameWeek - 1] {
            scores.removeAll()

            scores = fixture.map { score in
                ScoreModel(homeTeam: score.homeTeam, awayTeam: score.awayTeam, score: score.score, date: score.date.date)
            }
        }
    }

    func handleFixtures(competitionId: Int) async {
        do {
            let response = try await getFixtures(competitionId: competitionId)
            self.response = response
            leagueTitle = response.leagueTitle
            weeks = response.fixtures.map { fixture in
                let weekModel = WeekModel(number: fixture.first?.gameWeek ?? -1, description: "WEEK \(fixture.first?.gameWeek ?? -1)")
                if fixture.first?.gameWeek == response.nextWeek {
                    selectedWeek = weekModel

                    self.scores = fixture.map { score in
                        ScoreModel(homeTeam: score.homeTeam, awayTeam: score.awayTeam, score: score.score, date: score.date.date)
                    }
                }

                return weekModel
            }

            loading = false

        } catch {
            print(error.localizedDescription)
            loading = false
        }
    }
}
