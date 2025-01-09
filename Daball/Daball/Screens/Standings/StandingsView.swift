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

struct StandingRow: View {
    var data: StandingModel

    var body: some View {
        HStack {
            HStack(alignment: .center, spacing: 0) {
                Text(data.rank, format: .number)
                    .frame(width: 24)
                HStack {
                    AsyncImage(url: URL(string: data.logo)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "figure.soccer")
                    }
                    .frame(width: 24, height: 24)
                    .padding(8)
                    Text(data.name)
                }
                .frame(width: 160)

                Spacer()
            }

            Spacer()
            Divider()

            ScrollView(.horizontal) {
                HStack {
                    ForEach(data.stats) { stat in
                        Text(stat.value, format: .number)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(8)
                            .frame(width: 45)
                        Divider()
                    }
                }
            }
        }
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(stats) { stat in
                    Text(stat.shortDescription)
                        .font(.headline.bold())
                        .foregroundColor(Color.red)
                        .padding(8)
                        .frame(width: 45)
                    Divider()
                }
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(data.stats) { stat in
                    Text(stat.value, format: .number)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(8)
                        .frame(width: 45)
                    Divider()
                }
            }
        }
    }
}

struct StandingsView: View {
    @StateObject private var viewModel = StandingsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        StandingTableInfoHeader()
                        Divider()
                        ForEach(viewModel.standings) { standing in
                            StandingTeamInfoRow(data: standing)
                                .frame(height: 45)

                            Line()
                                .stroke(style: .init(dash: [2]))
                                .foregroundStyle(.primary).opacity(0.5)
                                .frame(height: 1)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)

                    VStack(spacing: 0) {
                        if let first = viewModel.standings.first {
                            StandingTableStatsHeader(stats: first.stats)
                            Divider()
                        }
                        ForEach(viewModel.standings) { standing in
                            StandingTeamStatsRow(data: standing)
                                .frame(height: 45)
                            Line()
                                .stroke(style: .init(dash: [2]))
                                .foregroundStyle(.primary).opacity(0.5)
                                .frame(height: 1)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            .navigationTitle(viewModel.leagueTitle)
            .task {
                await viewModel.handleStandings()
            }
        }
    }
}

#Preview {
    StandingsView()
}
