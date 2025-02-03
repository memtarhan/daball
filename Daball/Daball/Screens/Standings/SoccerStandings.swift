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

struct StandingTableLastGamesHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            HStack {
                Text("Last 5 Games")
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
                NavigationLink(destination: TeamDetailsView(teamId: data.id, teamName: data.name, lastFiveGames: data.lastFiveGames)) {
                    Text(data.name)
                        .font(.subheadline)
                }.buttonStyle(PlainButtonStyle())
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

struct LastFiveGamesView: View {
    var data: [LastGameModel]
    var body: some View {
        HStack(spacing: 4) {
            ForEach(data) { game in
                NavigationLink {
                    MatchDetailsView(matchId: game.id)
                } label: {
                    Text(game.status)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 32)
                        .background(getColor(for: game.status))
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .foregroundStyle(Color.primary)
                }

            }
            
            Spacer()
        }
        .frame(height: 45)
        .padding(.leading, 20)
    }

    private func getColor(for status: String) -> Color {
        switch status {
        case "W":
            return .green
        case "L":
            return .red
        default:
            return .gray
        }
    }
}

struct SoccerStandings: View {
    var data: [StandingModel]

    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    teamColumn
                        .frame(minWidth: 0)
                    statsColumn
                        .frame(minWidth: 0)
                    lastFiveGamesColumn
                        .frame(minWidth: 0)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    var lastFiveGamesColumn: some View {
        VStack(alignment: .leading, spacing: 0) {
            StandingTableLastGamesHeader()
                .frame(height: 45)
                .background(.secondary.quaternary)

            Divider()

            ForEach(data) { standing in
                VStack(spacing: 0) {
                    LastFiveGamesView(data: standing.lastFiveGames)
                        .frame(height: 45)

                    Line()
                        .stroke(style: .init(dash: [1]))
                        .foregroundStyle(.primary).opacity(0.3)
                        .frame(height: 1)
                }
            }

            Spacer()
        }
        .padding(.trailing, 12)
    }

    var teamColumn: some View {
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
    }

    var statsColumn: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 0) {
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
            }
        }
    }
}
