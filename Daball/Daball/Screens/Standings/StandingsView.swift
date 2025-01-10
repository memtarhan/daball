//
//  StandingsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct StandingTableInfoHeader: View {
    var body: some View {
        HStack(spacing: 32) {
            HStack {
                Text("Rk")
                Spacer()
                Text("Squad")
            }
            Spacer()
            Divider()
        }
        .font(.headline.bold())
        .foregroundStyle(Color.red)
        .padding(.leading, 20)
    }
}

struct StandingTableStatsHeader: View {
    var stats: [StatModel]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(stats) { stat in
                Text(stat.shortDescription)
                    .font(.headline.bold())
                    .foregroundColor(Color.red)
                    .padding(8)
                    .frame(width: 64)
                Divider()
            }
        }
    }
}

struct StandingTeamInfoRow: View {
    var data: StandingModel

    var body: some View {
        HStack(spacing: 2) {
            Text(data.rank, format: .number)
                .font(.title3.weight(.light))
                .frame(width: 24)
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: data.logo)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "figure.soccer")
                }
                .frame(width: 24)
                .padding(8)
                Text(data.name)
                    .font(.subheadline)
            }
            Spacer()
            Divider()
        }
        .padding(.leading, 20)
    }
}

struct StandingTeamStatsRow: View {
    var data: StandingModel

    var body: some View {
        HStack(spacing: 0) {
            ForEach(data.stats) { stat in
                Text(stat.value, format: .number)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(8)
                    .frame(width: 64)
                Divider()
            }
        }
    }
}

struct StandingsView: View {
    @StateObject private var viewModel = StandingsViewModel()
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel

    @State private var displayCompetitionsPopover: Bool = false

//    init(displayCompetitionsPopover: Bool) {
//        self.displayCompetitionsPopover = displayCompetitionsPopover
//    }

    var body: some View {
        NavigationStack {
            if viewModel.loading {
                ProgressView {
                    Text("Loading...")
                }

            } else {
                tableView
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

    var tableView: some View {
        ScrollView {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    StandingTableInfoHeader()
                        .frame(height: 45)
                        .background(.secondary.quaternary)

                    Divider()

                    ForEach(viewModel.standings) { standing in
                        VStack(spacing: 0) {
                            StandingTeamInfoRow(data: standing)
                                .frame(height: 45)

                            Line()
                                .stroke(style: .init(dash: [2]))
                                .foregroundStyle(.primary).opacity(0.5)
                                .frame(height: 1)
                        }
                        .scrollTransition(axis: .vertical) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .blur(radius: phase.isIdentity ? 0 : 10)
                        }
                    }

                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity)

                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 0) {
                        if let first = viewModel.standings.first {
                            StandingTableStatsHeader(stats: first.stats)
                                .frame(height: 45)
                                .background(.secondary.quaternary)

                            Divider()
                        }
                        ForEach(viewModel.standings) { standing in
                            VStack(spacing: 0) {
                                StandingTeamStatsRow(data: standing)
                                    .frame(height: 45)

                                Line()
                                    .stroke(style: .init(dash: [2]))
                                    .foregroundStyle(.primary).opacity(0.5)
                                    .frame(height: 1)
                            }
                            
                            .scrollTransition(axis: .vertical) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                                    .blur(radius: phase.isIdentity ? 0 : 10)
                                
                            }
                        }

                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    StandingsView()
        .environmentObject(CompetitionsViewModel())
}
