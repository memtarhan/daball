//
//  StatsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 10.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct StatSectionsView: View {
    @Binding var data: [SectionedStatModel]
    @Binding var selectedSection: SectionedStatModel?

    var body: some View {
        VStack {
            scrollView
                .frame(height: 36)
            Divider()
            if let items = selectedSection?.items {
                List(items) { item in
                    PlayerStatRow(data: item)
                }
                .listStyle(.plain)
            }
        }
    }

    var scrollView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(data) { section in
                        Text(section.title)
                            .foregroundStyle(selectedSection == section ? Color.red : Color.primary)
                            .padding(12)
                            .onTapGesture {
                                selectedSection = section
                                withAnimation {
                                    scrollProxy.scrollTo(section.id, anchor: .center)
                                }
                            }
                            .id(section.id)
                            .onAppear {
                                if selectedSection != nil {
                                    withAnimation {
                                        scrollProxy.scrollTo(selectedSection!, anchor: .center)
                                    }
                                }
                            }

                        Divider()
                    }
                }
            }
        }
    }
}

struct PlayerStatRow: View {
    var data: PlayerStatModel

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            HStack {
                if let rank = data.rank {
                    Text(rank, format: .number)
//                        .padding(4)
                        .font(.title.weight(.ultraLight))
                }
            }
            .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(data.player)
                    .font(.headline)
                Text(data.team)
                    .font(.subheadline)
            }

            Spacer()
            Text(data.value, format: .number)
                .font(.title3.weight(.semibold))
                .padding(.trailing, 20)
        }
    }
}

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel

    @State private var displayCompetitionsPopover: Bool = false

    var body: some View {
        NavigationStack {
            if viewModel.loading {
                ProgressView {
                    Text("Loading...")
                }

            } else {
                StatSectionsView(data: $viewModel.stats, selectedSection: $viewModel.selectedSection)
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
