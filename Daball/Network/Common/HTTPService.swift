//
//  HTTPService.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

protocol HTTPService {
    /// Handles HTTP call and retrieve a response for given url with no authorization
    /// - Parameter url: The url HTTP call should be pointed to
    /// - Returns: Returns a response of given type
    func handleDataTask<T: HTTPResponse>(from url: URL) async throws -> T
}

extension HTTPService {
    func handleDataTask<T: HTTPResponse>(from url: URL) async throws -> T {
        let (data, _) = try await session.data(from: url)
        data.printPrettied()
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: Private variables

private extension HTTPService {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }

    var session: URLSession {
        URLSession.shared
    }
}
