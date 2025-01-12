//
//  FixturesService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol FixturesService: HTTPService, FixturesEndpointsService {
    func getFixtures(competitionId: Int) async throws -> FixturesResponse
}

extension FixturesService {
    func getFixtures(competitionId: Int) async throws -> FixturesResponse {
        guard let endpoint = getFixturesURL(competitionId: competitionId) else {
            throw HTTPError.badURL
        }

        let response: FixturesResponse = try await handleDataTask(from: endpoint)
        return response
    }
}
