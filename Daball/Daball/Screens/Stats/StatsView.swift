//
//  StatsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 10.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct PlayerStatRow: View {
    var data: PlayerStatModel

    var body: some View {
        HStack(alignment: .center, spacing: 32) {
//            Text("1")
//                .padding(8)
//                .background(Color.green)
//                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(data.player)
                    .font(.headline)
                Text(data.team)
                    .font(.subheadline)
            }
            Spacer()
            Text(data.value, format: .number)
                .font(.title3.weight(.semibold))
        }
    }
}

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel

    @State private var displayCompetitionsPopover: Bool = false

    var body: some View {
        NavigationStack {
            List(viewModel.stats) { data in
                Section(header: Text(data.title)) {
                    ForEach(data.items) { item in
                        PlayerStatRow(data: item)
                    }
                }
            }
            .listStyle(.plain)
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
        .task {
            if let competitionId = competitionsViewModel.selectedCompetition?.id {
                await viewModel.handleStats(competitionId: competitionId)

            } else {
                await viewModel.handleStats(competitionId: 9)
            }
        }
    }
}

#Preview {
    StatsView()
        .environmentObject(CompetitionsViewModel())
}
