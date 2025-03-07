//
//  TeamDetailsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 2.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import BallKit
import SwiftUI

struct TeamInfoHeader: View {
    var logo: String
    var title: String

    var body: some View {
        HStack(alignment: .center) {
            TeamLogoView(url: logo)
                .frame(width: 48, height: 48)

            Text(title)
                .font(.headline)
            Spacer()
        }
    }
}

struct TeamDetailsRow: View {
    var data: TeamDetailsModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(data.description)
                .font(.subheadline)

            Text(data.details)
                .font(.body.weight(.thin))

            Spacer()
        }
    }
}

struct TeamDetailsView: View {
    @StateObject private var viewModel = TeamDetailsViewModel()

    var teamId: String
    var teamName: String
    var lastFiveGames: [LastGameData]

    var body: some View {
        NavigationStack {
            if viewModel.loading {
                ProgressView {
                    Text("Loading...")
                }

            } else {
                List {
                    TeamInfoHeader(logo: viewModel.logo, title: viewModel.title)

                    ForEach(viewModel.details) { details in
                        TeamDetailsRow(data: details)
                            .padding(.top, 20)
                            .padding(.bottom, -20)
                    }
                }
                .listStyle(.plain)
                .navigationTitle(teamName)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task {
            await viewModel.handleTeamDetails(teamId: teamId, lastFiveGames: lastFiveGames)
        }
    }
}

#Preview {
    TeamDetailsView(teamId: "206d90db", teamName: "Barcelona", lastFiveGames: [])
}
