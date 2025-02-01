//
//  TeamDetailsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 2.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct TeamDetailsModel: Identifiable {
    let description: String
    let details: String

    var id: String { description + details }
}

@MainActor
class TeamDetailsViewModel: ObservableObject, TeamDetailsService {
    @Published var loading: Bool = true
    @Published var title: String = ""
    @Published var logo: String = ""
    @Published var details: [TeamDetailsModel] = []

    func handleTeamDetails(teamId: String) async {
        do {
            let response = try await getDetails(teamId: teamId)
            title = response.title
            logo = response.logo
            details = response.details.map { TeamDetailsModel(description: $0.description, details: $0.details) }

            loading = false

        } catch {
            print(error.localizedDescription)
            loading = false
        }
    }
}
