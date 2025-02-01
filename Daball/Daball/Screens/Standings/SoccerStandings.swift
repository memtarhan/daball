//
//  SoccerStandings.swift
//  Daball
//
//  Created by Mehmet Tarhan on 1.02.2025.
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
        HStack(spacing: 8) {
            HStack {
                Text("Rk")
                Text("Squad")
                Spacer()
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
                Menu(stat.shortDescription) {
                    if let tooltip = stat.tooltip {
                        Text(tooltip)
                    }
                }
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

struct SoccerStandings: View {
    var data: [StandingModel]

    var body: some View {
        ScrollView {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    StandingTableInfoHeader()
                        .frame(height: 45)
                        .background(.secondary.quaternary)

                    Divider()

                    ForEach(data) { standing in
                        VStack(spacing: 0) {
                            StandingTeamInfoRow(data: standing)
                                .frame(height: 45)

                            Line()
                                .stroke(style: .init(dash: [1]))
                                .foregroundStyle(.primary).opacity(0.3)
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
                        if let first = data.first {
                            StandingTableStatsHeader(stats: first.stats)
                                .frame(height: 45)
                                .background(.secondary.quaternary)

                            Divider()
                        }
                        ForEach(data) { standing in
                            VStack(spacing: 0) {
                                StandingTeamStatsRow(data: standing)
                                    .frame(height: 45)

                                Line()
                                    .stroke(style: .init(dash: [1]))
                                    .foregroundStyle(.primary).opacity(0.3)
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
