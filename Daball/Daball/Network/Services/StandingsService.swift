//
//  StandingsService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol StandingsService: HTTPService, StandingsEndpointsService {
    func getStandings(competitionId: Int) async throws -> StandingsResponse
}

extension StandingsService {
    func getStandings(competitionId: Int) async throws -> StandingsResponse {
        guard let endpoint = getStandingsURL(competitionId: competitionId) else {
            throw HTTPError.badURL
        }

        let response: StandingsResponse = try await handleDataTask(from: endpoint)
        return response
    }
}
