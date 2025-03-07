//
//  MatchService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 3.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol MatchService: HTTPService, MatchEndpointsService {
    func getMatch(matchId: String) async throws -> MatchResponse
}

extension MatchService {
    func getMatch(matchId: String) async throws -> MatchResponse {
        guard let endpoint = getMatchURL(matchId: matchId) else {
            throw HTTPError.badURL
        }

        let response: MatchResponse = try await handleDataTask(from: endpoint)
        return response
    }
}
