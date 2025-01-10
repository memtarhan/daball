//
//  HTTPResponse.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol HTTPResponse: Decodable { }

// MARK: - CompetitionsResponse

struct CompetitionsResponse: HTTPResponse {
    let competitions: [CompetitionResponse]
}

// MARK: - CompetitionResponse

struct CompetitionResponse: HTTPResponse {
    let id: Int
    let name, displayName: String
    let logo: String
}

// MARK: - StandingsResponse

struct StandingsResponse: HTTPResponse {
    let leagueTitle: String
    let standings: [StandingResponse]
}

// MARK: - StandingResponse

struct StandingResponse: HTTPResponse {
    let rank: Int
    let points: Int
    let pointsAvg: Double?
    let name: String
    let logo: String
    let stats: [StatResponse]
    let xgStats: [StatResponse]
    let lastFiveGames: [LastFiveGame]
    let topScorer: String?
    let topGoalKeeper: String?
}

enum LastFiveGame: String, HTTPResponse {
    case win = "W"
    case draw = "D"
    case loss = "L"
}

// MARK: - StatResponse

struct StatResponse: HTTPResponse {
    let value: Double
    let description: String
    let shortDescription: String
}

// MARK: - FixturesResponse

struct FixturesResponse: HTTPResponse {
    let leagueTitle: String
    let fixtures: [[FixtureResponse]]
    let nextWeek: Int
}

// MARK: - FixtureResponse

struct FixtureResponse: HTTPResponse {
    let gameWeek: Int
    let homeTeam: String
//    let xgData: XgDataResponse?
    let awayTeam: String
    let homeTeamScore: Int?
    let awayTeamScore: Int?
    let date: DateResponse
//    let attendance: String?
    let venue: String?
}

// MARK: - DateResponse

struct DateResponse: HTTPResponse {
    let dayOfWeek: DayOfWeek
    let date: String
    let startTime: String
}

// MARK: - DayOfWeek

enum DayOfWeek: String, HTTPResponse {
    case fri = "Fri"
    case mon = "Mon"
    case sat = "Sat"
    case sun = "Sun"
    case thu = "Thu"
    case tue = "Tue"
    case wed = "Wed"
}

// MARK: - XgDataResponse

struct XgDataResponse: HTTPResponse {
    let homeTeamXg, awayTeamXg: String

    enum CodingKeys: String, CodingKey {
        case homeTeamXg = "home_team_xg"
        case awayTeamXg = "away_team_xg"
    }
}

// MARK: - StatsResponse

struct StatsResponse: HTTPResponse {
    let response: [PlayerStatResponse]
}

// MARK: - PlayerStatResponse

struct PlayerStatResponse: HTTPResponse {
    let title: String
    let id: String
    let items: [StatItemResponse]
}

// MARK: - StatItemResponse

struct StatItemResponse: HTTPResponse {
    let player: String
    let team: String
    let value: Double
    let rank: Int?
}
