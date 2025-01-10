//
//  CompetitionsViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation

struct CompetitionModel: Identifiable, Equatable {
    let id: Int
    let displayName: String
    let logo: String
}

@MainActor
class CompetitionsViewModel: ObservableObject, CompetitionsService {
    @Published var competitions: [CompetitionModel] = []

    @Published var selectedCompetition: CompetitionModel? {
        didSet {
            print(
                selectedCompetition!.displayName
            )
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
}
