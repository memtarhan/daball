//
//  EndpointsService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

private let baseURL = "http://127.0.0.1:8000"

protocol EndpointsService { }

protocol CompetitionsEndpointsService: EndpointsService {
    func getCompetitionsURL() -> URL?
}

extension CompetitionsEndpointsService {
    func getCompetitionsURL() -> URL? {
        URL(string: "\(baseURL)/competitions")
    }
}
