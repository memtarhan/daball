//
//  HTTPResponse.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol HTTPResponse: Decodable { }

// MARK: - CompetitionsResponse

struct CompetitionsResponse: HTTPResponse {
    let competitions: [CompetitionResponse]
}

// MARK: - CompetitionResponse

struct CompetitionResponse: HTTPResponse {
    let id: Int
    let name, displayName: String
    let logo: String
}
