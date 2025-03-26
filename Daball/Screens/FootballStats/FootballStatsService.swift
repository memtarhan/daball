//
//  FootballStatsService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 26.03.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol FootballStatsService {
    func fetchStats() async throws -> FootballStatsResponse
}

struct FootballStatsServiceImpl: FootballStatsService {
    private let networkWrapper: NetworkWrapper

    init(networkWrapper: NetworkWrapper) {
        self.networkWrapper = networkWrapper
    }
    
    func fetchStats() async throws -> FootballStatsResponse {
        let url = URL(string: "http://127.0.0.1:8000/football/competitions/12/stats")!
        let response: FootballStatsResponse = try await networkWrapper.client.handleDataTask(from: url)
        return response
    }
}
