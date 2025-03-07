//
//  CurrentService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 12.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol CurrentService: HTTPService, CurrentEndpointsService {
    func getCurrent() async throws -> CurrentResponse
}

extension CurrentService {
    func getCurrent() async throws -> CurrentResponse {
        guard let endpoint = getCurrentURL() else {
            throw HTTPError.badURL
        }
        
        let response: CurrentResponse = try await handleDataTask(from: endpoint)
        return response
    }
    
}
