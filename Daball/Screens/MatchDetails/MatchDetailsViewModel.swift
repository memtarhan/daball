//
//  MatchDetailsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 3.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct MatchStatTeamModel {
    let percentage: String?
    let success: Int?
    let total: Int?
    var items: [String]? = nil

    var successWeight: Double {
        if let success,
           let total {
            return CGFloat(success) / CGFloat(total)
        }
        return 1
    }
}

struct MatchStatModel: Identifiable {
    let title: String
    let homeTeam: MatchStatTeamModel
    let awayTeam: MatchStatTeamModel

    var homeTeamWidthWeight: CGFloat {
        if awayTeamWidthWeight == 1.0 {
            return 1.0
        } else {
            let width = 1.0 - awayTeamWidthWeight
            return width
        }
    }

    var awayTeamWidthWeight: CGFloat {
        if let totalAway = awayTeam.total,
           let totalHome = homeTeam.total {
            var weight: CGFloat = 1
            if totalAway > totalHome {
                let w = CGFloat(totalHome) / CGFloat(totalAway)
                weight = 1.0 - w

            } else if totalAway < totalHome {
                weight = CGFloat(totalAway) / CGFloat(totalHome)

            } else {
                weight = 1.0
            }

            return weight

        } else {
            return 1.0
        }
    }

    var id: String { title }

    static let sample = MatchStatModel(title: "Passing Accuracy",
                                       homeTeam: MatchStatTeamModel(percentage: "81%",
                                                                    success: 324,
                                                                    total: 402),
                                       awayTeam: MatchStatTeamModel(percentage: "87%",
                                                                    success: 578,
                                                                    total: 663))

    static let sample2 = MatchStatModel(title: "Cards",
                                        homeTeam: MatchStatTeamModel(percentage: nil,
                                                                     success: nil,
                                                                     total: nil,
                                                                     items: ["yellow_card", "yellow_card", "red_card"]),
                                        awayTeam: MatchStatTeamModel(percentage: nil,
                                                                     success: nil,
                                                                     total: nil,
                                                                     items: ["red_card"]))
}

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

struct MatchEventModel: Identifiable {
    let title: String
    let value: String
    let iconName: String
    let type: MatchEventType

    var id: String { title + value }
}

struct MatchExtendedStatsGroupModel: Identifiable {
    let id: UUID = UUID()
    let stats: [MatchExtendedStatsModel]
}

struct MatchExtendedStatsModel: Identifiable {
    let description: String
    let homeTeamValue: Int
    let awayTeamValue: Int

    var id: String { description }

    static let sample = MatchExtendedStatsModel(
        description: "Corners",
        homeTeamValue: 10,
        awayTeamValue: 8
    )
}

@MainActor
class MatchDetailsViewModel: ObservableObject, MatchService {
    @Published var loading: Bool = true
    @Published var title: String = ""
    @Published var matchTeams: [MatchTeamModel] = []
    @Published var details: MatchDetailsModel?
    @Published var homeTeamEvents: [MatchEventModel] = []
    @Published var awayTeamEvents: [MatchEventModel] = []
    @Published var matchStats: [MatchStatModel] = []
    @Published var extendedStats: [MatchExtendedStatsGroupModel] = []

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

            homeTeamEvents = response.events.homeTeam.map { event in
                MatchEventModel(title: event.title,
                                value: event.value,
                                iconName: event.type == .goal ? "soccerball" : "rectangle.portrait.fill",
                                type: event.type)
            }

            awayTeamEvents = response.events.awayTeam.map { event in
                MatchEventModel(title: event.title,
                                value: event.value,
                                iconName: event.type == .goal ? "soccerball" : "rectangle.portrait.fill",
                                type: event.type)
            }

            matchStats = response.stats.map { stats in
                MatchStatModel(title: stats.type.capitalized,
                               homeTeam: MatchStatTeamModel(percentage: stats.homeTeam.percentage,
                                                            success: stats.homeTeam.success,
                                                            total: stats.homeTeam.total,
                                                            items: stats.homeTeam.items),
                               awayTeam: MatchStatTeamModel(percentage: stats.awayTeam.percentage,
                                                            success: stats.awayTeam.success,
                                                            total: stats.awayTeam.total,
                                                            items: stats.awayTeam.items))
            }

            let extendedStatsModels = response.extendedStats.map { stats in
                MatchExtendedStatsModel(description: stats.description,
                                        homeTeamValue: stats.homeTeamValue,
                                        awayTeamValue: stats.awayTeamValue)
            }.chunked(into: 10)

            extendedStats = extendedStatsModels.map { group in
                MatchExtendedStatsGroupModel(stats: group)
            }

            loading = false
        } catch {
            print(error.localizedDescription)
            loading = false
        }
    }
}
