//
//  MatchDetailsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 3.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

@MainActor
class MatchDetailsViewModel: ObservableObject, MatchService {
    @Published var loading: Bool = true
    @Published var title: String = ""

    func handleMatch(matchId: String) async {
        do {
            let response = try await getMatch(matchId: matchId)
            title = response.title
            loading = false
        } catch {
            print(error.localizedDescription)
            loading = false
        }
    }
}
