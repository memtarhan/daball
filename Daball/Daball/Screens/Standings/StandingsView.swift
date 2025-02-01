//
//  StandingsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct StandingsView: View {
    @StateObject private var viewModel = StandingsViewModel()
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel

    @State private var displayCompetitionsPopover: Bool = false

    var body: some View {
        NavigationStack {
            if viewModel.loading {
                ProgressView {
                    Text("Loading...")
                }

            } else {
                SoccerStandings(data: viewModel.standings)
                    .navigationTitle(competitionsViewModel.selectedCompetition?.displayName ?? "...")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button {
                                displayCompetitionsPopover = true
                            } label: {
                                Image(systemName: displayCompetitionsPopover ? "chevron.up" : "chevron.down")
                            }
                        }
                    }
            }
        }
        .task {
            if let competitionId = competitionsViewModel.selectedCompetition?.id {
                viewModel.reset(competitionId: competitionId)
                displayCompetitionsPopover = false
            } else {
                displayCompetitionsPopover = true
            }
        }
        .onChange(of: competitionsViewModel.selectedCompetition) { _, newValue in
            if let competitionId = newValue?.id {
                viewModel.reset(competitionId: competitionId)
                displayCompetitionsPopover = false
            }
        }
        .sheet(isPresented: $displayCompetitionsPopover) {
            CompetitionsView()
                .environmentObject(competitionsViewModel)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    StandingsView()
        .environmentObject(CompetitionsViewModel())
}
