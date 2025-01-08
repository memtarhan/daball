//
//  CompetitionsService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol CompetitionsService: HTTPService, CompetitionsEndpointsService {
    func getCompetitions() async throws -> [CompetitionResponse]
}

extension CompetitionsService {
    func getCompetitions() async throws -> [CompetitionResponse] {
        guard let endpoint = getCompetitionsURL() else {
            throw HTTPError.badURL
        }

        let response: CompetitionsResponse = try await handleDataTask(from: endpoint)
        return response.competitions
    }
}
