//
//  DaballApp.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//

import Networkable
import SwiftUI

@main
struct DaballApp: App {
    @StateObject var competitionsViewModel: CompetitionsViewModel = CompetitionsViewModel()
    @State private var footballStatsModel: FootballStatsModel

    init() {
        // MARK: Dependency injection

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let networkClient: NetworkableClient = NetworkableDefaultClient(decoder: decoder)
        let networkWrapper = NetworkWrapper(client: networkClient)

        let footballStatsService: FootballStatsService = FootballStatsServiceImpl(networkWrapper: networkWrapper)
        footballStatsModel = FootballStatsModel(service: footballStatsService)
    }

    var body: some Scene {
        WindowGroup {
            FootballStatsView()
                .environment(footballStatsModel)
        }
    }
}
