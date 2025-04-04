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

struct LeagueTableResponse: HTTPResponse {
    let phases: [LeaguePhaseResponse]
}

struct LeaguePhaseResponse: HTTPResponse {
    let matches: [KnockoutPhaseMatchResponse]?
    let title: String
    let type: LeaguePhaseType
    let description: String?
    let standings: [StandingResponse]?
    let statTypes: [StatTypeResponse]?
}

enum LeaguePhaseType: String, HTTPResponse {
    case knockout
    case league
}

// MARK: - KnockoutPhaseResponse

struct KnockoutPhaseResponse: HTTPResponse {
    let matches: [KnockoutPhaseMatchResponse]
    let title: String
    let description: String
}

// MARK: - KnockoutPhaseMatchResponse

struct KnockoutPhaseMatchResponse: HTTPResponse {
    let teams: [KnockoutTeamResponse]
    let matches: [KnockoutMatchResponse]
    let notes: String
}

// MARK: - KnockoutMatchResponse

struct KnockoutMatchResponse: HTTPResponse {
    let homeTeam: String
    let awayTeam: String
    let time: String
    let date: String
}

// MARK: - KnockoutTeamResponse

struct KnockoutTeamResponse: HTTPResponse {
    let name: String
    let id: String
    let logo: String
}

// MARK: - StandingsResponse

struct StandingsResponse: HTTPResponse {
    let leagueTitle: String
    let standings: [StandingResponse]
    let statTypes: [StatTypeResponse]
}

// MARK: - StandingResponse

struct StandingResponse: HTTPResponse {
    let rank: Int
    let points: Int
    let pointsAvg: Double?
    let name: String
    let teamId: String
    let logo: String
    let stats: [StatResponse]
    let xgStats: [StatResponse]
    let lastFiveGames: [LastFiveGameResponse]
    let topScorer: String?
    let topGoalKeeper: String?
}

// MARK: - LastFiveGameResponse

struct LastFiveGameResponse: HTTPResponse {
    let id: String
    let status: LastFiveGameStatus
}

enum LastFiveGameStatus: String, HTTPResponse {
    case win = "W"
    case draw = "D"
    case loss = "L"
}

// MARK: - StatTypeResponse

struct StatTypeResponse: HTTPResponse {
    let type: String
    let description: String
    let shortDescription: String
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
    let fixtures: [FixtureResponse]
    let nextWeek: Int?
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

// MARK: - CurrentResponse

struct CurrentResponse: HTTPResponse {
    let response: [CurrentDataResponse]
}

// MARK: - CurrentDataResponse

struct CurrentDataResponse: HTTPResponse {
    let leaders: [LeaderSimpleResponse]
    let title: String
    let country: String
    let standings: [StandingSimpleResponse]
}

// MARK: - LeaderSimpleResponse

struct LeaderSimpleResponse: HTTPResponse {
    let players: [String]
    let value: Double
    let description: String
}

// MARK: - StandingSimpleResponse

struct StandingSimpleResponse: HTTPResponse {
    let team: String
    let stats: [StatSimpleResponse]
    let rank: String
}

// MARK: - StatSimpleResponse

struct StatSimpleResponse: HTTPResponse {
    let value: String
    let shortDescription: String
    let description: String
}

// MARK: - TeamResponse

struct TeamResponse: HTTPResponse {
    let title: String
    let logo: String
    let teamId: String
    let details: [TeamDetailsResponse]
}

// MARK: - TeamDetailsResponse

struct TeamDetailsResponse: HTTPResponse {
    let description: String
    let details: String
}

// MARK: - MatchResponse

struct MatchResponse: HTTPResponse {
    let title: String
    let matchWeek: String
    let teams: [MatchTeamResponse]
    let date: MatchDateResponse
    let events: MatchEventsResponse
    let details: [MatchDetailResponse]
    let stats: [MatchStatsResponse]
    let extendedStats: [MatchExtendedStatsResponse]
}

struct MatchEventsResponse: HTTPResponse {
    let homeTeam: [MatchEventResponse]
    let awayTeam: [MatchEventResponse]
}

// MARK: - MatchEventResponse

struct MatchEventResponse: HTTPResponse {
    let title: String
    let value: String
    let type: MatchEventType
}

// MARK: - MatchEventType

enum MatchEventType: String, HTTPResponse {
    case redCard = "red_card"
    case goal
}

// MARK: - MatchDateResponse

struct MatchDateResponse: HTTPResponse {
    let date: String
    let time: String
    let epoch: Double
}

// MARK: - MatchDetailResponse

struct MatchDetailResponse: HTTPResponse {
    let description: String
    let value: String
}

// MARK: - MatchTeamResponse

struct MatchTeamResponse: HTTPResponse {
    let name: String
    let id: String
    let logo: String
    let score: String
    let scoreXg: String?
    let dataPoints: [MatchDetailResponse]
    let currentStats: String
}

// MARK: - MatchStatsResponse

struct MatchStatsResponse: HTTPResponse {
    let type: String
    let homeTeam: MatchStatResponse
    let awayTeam: MatchStatResponse
}

// MARK: - MatchStatResponse

struct MatchStatResponse: HTTPResponse {
    let percentage: String?
    let success: Int?
    let total: Int?
    let items: [String]?
}

// MARK: - MatchExtendedStatsResponse

struct MatchExtendedStatsResponse: HTTPResponse {
    let description: String
    let homeTeamValue: Int
    let awayTeamValue: Int
}

struct FootballStatsResponse: Decodable {
    let stats: [FootballStatResponse]
}

struct FootballStatResponse: Decodable {
    let title: String
    let id: String
    let items: [FootballIndividualStatResponse]
}

struct FootballIndividualStatResponse: Decodable {
    let player: String
    let team: String
    let teamLogo: String?
    let rank: Int?
    let value: Double
}
