//
//  TeamDetailsService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 2.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol TeamDetailsService: HTTPService, TeamDetailsEndpointsService {
    func getDetails(teamId: String) async throws -> TeamResponse
}

extension TeamDetailsService {
    func getDetails(teamId: String) async throws -> TeamResponse {
        guard let endpoint = getDetailsURL(teamId: teamId) else {
            throw HTTPError.badURL
        }

        let response: TeamResponse = try await handleDataTask(from: endpoint)
        return response
    }
}
