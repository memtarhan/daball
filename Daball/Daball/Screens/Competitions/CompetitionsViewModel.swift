//
//  CompetitionsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct CompetitionModel: Identifiable, Equatable, Codable {
    let id: Int
    let displayName: String
    let logo: String
}

@MainActor
class CompetitionsViewModel: ObservableObject, CompetitionsService {
    @Published var competitions: [CompetitionModel] = []

    @Published var selectedCompetition: CompetitionModel? {
        didSet {
            try? saveSelectedCompetition()
        }
    }

    @UserDefaultable(key: "selectedCompetition", defaultValue: nil)
    var savedSelectedCompetition: Data?

    init() {
        if let savedSelectedCompetition = try? retrieveSelectedCompetition() {
            selectedCompetition = savedSelectedCompetition
        }
    }
    
    func handleCompetitions() async {
        do {
            let response = try await getCompetitions()
            competitions = response
                .map {
                    CompetitionModel(
                        id: $0.id,
                        displayName: $0.displayName,
                        logo: $0.logo
                    )
                }

        } catch {
            print(
                error.localizedDescription
            )
        }
    }

    private func retrieveSelectedCompetition() throws -> CompetitionModel? {
        guard let data = savedSelectedCompetition else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(CompetitionModel.self, from: data)
    }

    private func saveSelectedCompetition() throws {
        guard let value = selectedCompetition else { return }
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)

        savedSelectedCompetition = data
    }
}
