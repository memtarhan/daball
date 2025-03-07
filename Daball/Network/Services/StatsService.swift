//
//  StatsService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 10.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol StatsService: HTTPService, StatsEndpointsService {
    func getStats(competitionId: Int) async throws -> StatsResponse
}

extension StatsService {
    func getStats(competitionId: Int) async throws -> StatsResponse {
        guard let endpoint = getStatsURL(competitionId: competitionId) else {
            throw HTTPError.badURL
        }

        let response: StatsResponse = try await handleDataTask(from: endpoint)
        return response
    }
}
