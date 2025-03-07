//
//  CurrentView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 12.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct LeagueLeaderRow: View {
    var data: LeagueLeaderSimpleModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(data.description)
                .font(.subheadline)

            HStack(alignment: .center, spacing: 4) {
                VStack(alignment: .leading) {
                    ForEach(data.players, id: \.self) { player in
                        Text(player)
                            .font(.headline.weight(.thin))
                    }
                }

                Spacer()
                Text(data.value, format: .number)
                    .font(.headline.weight(.medium))
            }
        }
    }
}

struct LeagueLeadersView: View {
    @State var expanded: Bool = true
    var data: [LeagueLeaderSimpleModel]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Stat Leaders")
                    .font(.headline)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        expanded.toggle()
                    }

                } label: {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Color.primary)
                }
            }
            .padding()
            .background(Color.primary.quinary.tertiary.opacity(0.4))

            if expanded {
                ForEach(data) { leader in
                    LeagueLeaderRow(data: leader)
                        .padding()

                    Divider()
                        .padding(4)
                }
            }
        }
        .background(Color.primary.quinary.opacity(0.3))
    }
}

struct LeagueStandingRow: View {
    var data: StandingSimpleModel

    var body: some View {
        HStack(spacing: 4) {
            HStack {
                Text(data.rank)
                    .frame(width: 18)

                Divider()
                Text(data.team)
                Spacer()
            }
            .font(.subheadline)
            .frame(minWidth: 0, maxWidth: .infinity)

            Divider()
            HStack(alignment: .center, spacing: 0) {
                ForEach(data.stats) { stat in
                    Text(stat.value)
                        .font(.subheadline)
//                            .padding(.horizontal, 4)
                        .frame(minWidth: 30)
                    Divider()
                }
            }
//                .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

struct LeagueStandingHeader: View {
    var data: LeagueModel

    var body: some View {
        HStack(spacing: 4) {
            HStack {
                Text("Rk")
                    .frame(width: 18)
                Divider()

                Text("Squad")
                Spacer()
            }
            .font(.subheadline)
            .frame(minWidth: 0, maxWidth: .infinity)

            Divider()
            if let team = data.standings.first {
                HStack(spacing: 0) {
                    ForEach(team.stats) { stat in
                        Text(stat.shortDescription)
                            .font(.subheadline)
//                            .padding(.horizontal, 4)
                            .frame(minWidth: 30)
                        Divider()
                    }
                }
//                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

struct LeageRow: View {
    var data: LeagueModel
    @Binding var expandedLeagues: [LeagueModel]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.element)
                .padding(.horizontal)
                .northWestShadow()

            VStack(alignment: .leading, spacing: 0) {
                // Standings
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(data.title)
                            .font(.headline)
                        Text(data.country)
                            .font(.subheadline)
                        Spacer()
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                if expandedLeagues.contains(where: { $0.title == data.title }) {
                                    expandedLeagues.removeAll(where: { $0.title == data.title })

                                } else {
                                    expandedLeagues.append(data)
                                }
                            }

                        } label: {
                            Image(systemName: expandedLeagues.contains(where: { $0.title == data.title }) ? "chevron.up" : "chevron.down")
                                .foregroundStyle(Color.primary)
                        }
                    }
                    .padding()
                    .background(Color.primary.tertiary)

                    if expandedLeagues.contains(where: { $0.title == data.title }) {
                        VStack(alignment: .leading, spacing: 0) {
                            LeagueStandingHeader(data: data)
                                .padding()
                                .background(Color.primary.quaternary)

                            Divider()

                            VStack {
                                ForEach(data.standings) { team in
                                    LeagueStandingRow(data: team)
                                    Divider()
                                }
                            }
                            .padding()
                            .background(Color.primary.quinary)
                        }
                    }

                    LeagueLeadersView(data: data.leaders)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
        }
    }
}

struct CurrentView: View {
    @StateObject private var viewModel = CurrentViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.element
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    if viewModel.loading {
                        ProgressView {
                            Text("Loading...")
                        }

                    } else {
                        ScrollView {
                            ForEach(viewModel.leagues) { league in
                                LeageRow(data: league, expandedLeagues: $viewModel.expandedLeagues)
//                                    .northWestShadow()
                            }
                        }
                    }
                }
                .navigationTitle("Current")
            }
        }
        .task {
            await viewModel.handleCurrent()
        }
    }
}

#Preview {
    CurrentView()
}
