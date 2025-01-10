//
//  EndpointsService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

//fileprivate let baseURL = "http://127.0.0.1:8000"
fileprivate let baseURL = "https://daball-api-d8834becc870.herokuapp.com"

protocol EndpointsService { }

protocol CompetitionsEndpointsService: EndpointsService {
    func getCompetitionsURL() -> URL?
}

extension CompetitionsEndpointsService {
    func getCompetitionsURL() -> URL? {
        URL(string: "\(baseURL)/competitions")
    }
}

protocol StandingsEndpointsService: EndpointsService {
    func getStandingsURL(competitionId: Int) -> URL?
}

extension StandingsEndpointsService {
    func getStandingsURL(competitionId: Int) -> URL? {
        URL(string: "\(baseURL)/competitions/\(competitionId)/standings")
    }
}

protocol FixturesEndpointsService: EndpointsService {
    func getFixturesURL(competitionId: Int) -> URL?
}

extension FixturesEndpointsService {
    func getFixturesURL(competitionId: Int) -> URL? {
        URL(string: "\(baseURL)/competitions/\(competitionId)/fixtures")
    }
}

protocol StatsEndpointsService: EndpointsService {
    func getStatsURL(competitionId: Int) -> URL?
}

extension StatsEndpointsService {
    func getStatsURL(competitionId: Int) -> URL? {
        URL(string: "\(baseURL)/competitions/\(competitionId)/stats")
    }
}
