//
//  MatchExtendedStatsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 4.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct MatchExtendedStatRow: View {
    var stats: MatchExtendedStatsModel

    var body: some View {
        HStack(alignment: .center) {
            Text(stats.homeTeamValue, format: .number)
                .font(.title2.weight(.thin))
                .frame(minWidth: 0, maxWidth: .infinity)

            Text(stats.description)
                .font(.subheadline.weight(.medium))
                .frame(minWidth: 0, maxWidth: .infinity)

            Text(stats.awayTeamValue, format: .number)
                .font(.title2.weight(.thin))
                .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

struct MatchExtendedStatsView: View {
    var data: [MatchExtendedStatsGroupModel]
    var homeTeamName: String
    var awayTeamName: String

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 20) {
                HStack(alignment: .center) {
                    Text(homeTeamName)
                        .font(.title3.weight(.semibold))
                    Spacer()

                }
                .frame(minWidth: 0, maxWidth: .infinity)

                HStack(alignment: .center) {
                    Spacer()

                    Text(awayTeamName)
                        .font(.title3.weight(.semibold))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)

            ForEach(data) { part in
                Group {
                    VStack {
                        ForEach(part.stats) { stats in
                            MatchExtendedStatRow(stats: stats)
                            Divider()
                                .padding(.horizontal, 32)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MatchExtendedStatsView(data: [MatchExtendedStatsGroupModel(stats: [MatchExtendedStatsModel.sample])],
                           homeTeamName: "Team A",
                           awayTeamName: "Team B")
}
