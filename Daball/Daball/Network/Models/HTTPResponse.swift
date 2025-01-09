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
    let pointsAvg: Double
    let name: String
    let logo: String
    let stats: [StatResponse]
    let xgStats: [StatResponse]
    let lastFiveGames: [LastFiveGame]
    let topScorer: String
    let topGoalKeeper: String
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
