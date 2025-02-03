//
//  KnockoutPhaseView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 3.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct TeamLogoView: View {
    var url: String
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "figure.soccer")
        }
    }
}

struct KnockoutPhaseTeamsRow: View {
    var teams: [KnockoutPhaseTeamModel]
    var body: some View {
        HStack(alignment: .center) {
            if let team = teams.first {
                HStack(alignment: .center) {
                    Spacer()
                    TeamLogoView(url: team.logo)
                        .frame(width: 24, height: 24)
                    Text(team.name)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }

            Image(systemName: "soccerball.inverse")
                .foregroundStyle(Color.green)

            if let team = teams.last {
                HStack(alignment: .center) {
                    Text(team.name)

                    TeamLogoView(url: team.logo)
                        .frame(width: 24, height: 24)

                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
        .font(.headline)
    }
}

struct KnockoutPhaseMatchesRow: View {
    var matches: [KnockoutPhaseMatchModel]

    var body: some View {
        VStack {
            ForEach(matches) { match in
                HStack {
                    HStack {
                        Text(match.homeTeam)
                        Text("-")
                        Text(match.awayTeam)
                    }
                    .font(.subheadline)

                    Spacer()

                    HStack {
                        Text("at")
                        Text("\(match.time) \(match.date)")
                    }
                    .font(.caption)
                }
            }
        }
    }
}

struct KnockoutPhaseRow: View {
    var data: KnockoutPhaseModel
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            KnockoutPhaseTeamsRow(teams: data.teams)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)

            Line()
                .stroke(style: .init(dash: [10]))
                .foregroundStyle(.primary).opacity(0.3)
                .frame(height: 1)
                .padding(.horizontal, 32)

            KnockoutPhaseMatchesRow(matches: data.matches)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)

            Line()
                .stroke(style: .init(dash: [10]))
                .foregroundStyle(.primary).opacity(0.3)
                .frame(height: 1)
                .padding(.horizontal, 32)

            Text(data.notes)
                .font(.footnote)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
        }
    }
}

struct KnockoutPhaseView: View {
    var data: [KnockoutPhaseModel]

    var body: some View {
        ScrollView {
            ForEach(data) { knockout in
                KnockoutPhaseRow(data: knockout)
                    .background(Color.element)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
//                    .northWestShadow()
            }
        }
    }
}

#Preview {
    KnockoutPhaseView(data: [KnockoutPhaseModel.sample])
}
