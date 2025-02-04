//
//  MatchStatsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 4.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct MatchStatRow: View {
    var data: MatchStatModel
    var proxy: GeometryProxy

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(data.title)
                .font(.title3.weight(.semibold))
            HStack(alignment: .center, spacing: 20) {
                homeTeamView
                    .frame(minWidth: 0, maxWidth: .infinity)
                Divider()
                awayTeamView
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.bottom, 12)
        }
    }

    private var homeTeamView: some View {
        VStack(alignment: .trailing) {
            if let items = data.homeTeam.items {
                HStack(spacing: 2) {
                    Spacer()
                    ForEach(items, id: \.self) { item in
                        Image(systemName: "rectangle.portrait.fill")
                            .font(.title2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(item == "yellow_card" ? .yellow : .red)
                    }
                }
            } else {
                HStack(alignment: .center) {
                    Spacer()

                    Text("\(data.homeTeam.success ?? 1) of \(data.homeTeam.total ?? 1)")
                        .font(.subheadline)

                    Text(" - ")
                        .font(.headline)

                    Text(data.homeTeam.percentage ?? "")
                        .font(.headline)
                }
                HStack {
                    Spacer()
                    ZStack(alignment: .trailing) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: getUsableWidth(proxy: proxy) * data.homeTeamWidthWeight, height: 20)
                        Capsule()
                            .fill(Color.green)
                            .frame(width: getUsableWidth(proxy: proxy) * data.homeTeamWidthWeight * data.homeTeam.successWeight, height: 20)
                    }
                }
            }
        }
    }

    private var awayTeamView: some View {
        VStack(alignment: .leading) {
            if let items = data.awayTeam.items {
                HStack(spacing: 2) {
                    ForEach(items, id: \.self) { item in
                        Image(systemName: "rectangle.portrait.fill")
                            .font(.title2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(item == "yellow_card" ? .yellow : .red)
                    }
                    Spacer()
                }
            } else {
                HStack(alignment: .center) {
                    Text(data.awayTeam.percentage ?? "")
                        .font(.headline)

                    Text(" - ")
                        .font(.headline)

                    Text("\(data.awayTeam.success ?? 1) of \(data.awayTeam.total ?? 1)")
                        .font(.subheadline)

                    Spacer()
                }
                HStack {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: getUsableWidth(proxy: proxy) * data.awayTeamWidthWeight, height: 20)
                        Capsule()
                            .fill(Color.green)
                            .frame(width: getUsableWidth(proxy: proxy) * data.awayTeamWidthWeight * data.awayTeam.successWeight, height: 20)
                    }
                    Spacer()
                }
            }
        }
    }

    func getUsableWidth(proxy: GeometryProxy) -> CGFloat {
        proxy.size.width * 0.4
    }
}

struct MatchStatsView: View {
    var data: [MatchStatModel]
    var proxy: GeometryProxy

    var body: some View {
        VStack {
            ForEach(data) { stats in
                MatchStatRow(data: stats, proxy: proxy)
//                    .padding()
            }
        }
    }
}

//#Preview {
//    MatchStatsView(data: [MatchStatModel.sample, MatchStatModel.sample2])
//}
