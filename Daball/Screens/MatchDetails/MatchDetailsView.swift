//
//  MatchDetailsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 3.02.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct MatchDetailsView: View {
    @StateObject private var viewModel = MatchDetailsViewModel()

    var matchId: String

    var body: some View {
        GeometryReader { proxy in

            NavigationStack {
                ZStack {
                    Color.element
                        .ignoresSafeArea(.all)

                    if viewModel.loading {
                        ProgressView {
                            Text("Loading...")
                        }

                    } else {
                        ScrollView {
                            if !viewModel.matchTeams.isEmpty {
                                VStack(alignment: .center, spacing: 20) {
                                    VStack {
                                        HStack(alignment: .center) {
                                            homeTeamView
                                                .frame(minWidth: 0, maxWidth: .infinity)

                                            scoreView

                                            awayTeamView
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                        }
                                        eventsView
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 12)
                                    }
                                    .padding(.vertical, 16)
                                    .background(Color.systemBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
                                    .padding(.horizontal, 8)
                                    .northWestShadow(radius: 12)

                                    MatchStatsView(data: viewModel.matchStats,
                                                   homeTeamName: viewModel.matchTeams[0].name,
                                                   homeTeamLogo: viewModel.matchTeams[0].logo,
                                                   awayTeamName: viewModel.matchTeams[1].name,
                                                   awayTeamLogo: viewModel.matchTeams[1].logo,
                                                   width: proxy.size.width)
                                        .padding(.vertical, 16)
                                        .background(Color.systemBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
                                        .padding(.horizontal, 8)
                                        .northWestShadow(radius: 12)

                                    MatchExtendedStatsView(data: viewModel.extendedStats,
                                                           homeTeamName: viewModel.matchTeams[0].name,
                                                           awayTeamName: viewModel.matchTeams[1].name)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 20)

                                    if let details = viewModel.details {
                                        getMatchDetailsView(details)
                                            .padding(.horizontal, 8)
                                    }
                                }
                            }

                            Spacer()
                        }
                        .navigationTitle("Match Details")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .task {
                    await viewModel.handleMatch(matchId: matchId)
                }
            }
        }
    }

    private var homeTeamView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                TeamLogoView(url: viewModel.matchTeams[0].logo)
                    .frame(width: 64, height: 64)
                    .padding(.bottom, 12)

                Text(viewModel.matchTeams[0].name)
                    .font(.title2.weight(.semibold))
                    .underline()
                Text(viewModel.matchTeams[0].currentStats)
                    .padding(.top, 4)
            }

            VStack(alignment: .center) {
                ForEach(viewModel.matchTeams[0].dataPoints) { data in
                    HStack(alignment: .center, spacing: 2) {
                        Text("\(data.description):")
                            .font(.subheadline.weight(.semibold))
                        Text(data.value)
                            .font(.subheadline.weight(.thin))
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
            }
            .padding(.top, 20)
            .padding(.leading, 8)
        }
    }

    private var awayTeamView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                TeamLogoView(url: viewModel.matchTeams[1].logo)
                    .frame(width: 64, height: 64)
                    .padding(.bottom, 12)

                Text(viewModel.matchTeams[1].name)
                    .font(.title2.weight(.semibold))
                    .underline()
                Text(viewModel.matchTeams[1].currentStats)
                    .padding(.top, 4)
            }

            VStack(alignment: .center) {
                ForEach(viewModel.matchTeams[1].dataPoints) { data in
                    HStack(alignment: .center, spacing: 2) {
                        Text("\(data.description):")
                            .font(.subheadline.weight(.semibold))
                        Text(data.value)
                            .font(.subheadline.weight(.thin))
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
            }
            .padding(.top, 20)
            .padding(.trailing, 8)
        }
    }

    private var scoreView: some View {
        VStack {
            HStack {
                Text(viewModel.matchTeams[0].score)
                Text(":")
                Text(viewModel.matchTeams[1].score)
            }
            .font(.largeTitle.weight(.medium))

            if let homeXg = viewModel.matchTeams[0].scoreXg,
               let awayXg = viewModel.matchTeams[1].scoreXg {
                VStack {
                    Text("xG")
                        .fontWeight(.semibold)
                    HStack {
                        Text(homeXg)
                        Text(":")
                        Text(awayXg)
                    }
                }
                .font(.subheadline)
            }
        }
    }

    private var eventsView: some View {
        HStack {
            VStack(alignment: .center) {
                ForEach(viewModel.homeTeamEvents) { event in
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Spacer()

                        HStack(alignment: .center, spacing: 2) {
                            Text(event.title)
                                .font(.subheadline)
                            Text(" · ")
                                .font(.headline)
                            Text(event.value)
                                .font(.body.weight(.thin))
                        }

                        Image(systemName: event.iconName)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(event.type == .redCard ? .red : .green)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)

            Divider()

            VStack(alignment: .center) {
                ForEach(viewModel.awayTeamEvents) { event in
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Image(systemName: event.iconName)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(event.type == .redCard ? .red : .green)

                        HStack(alignment: .center, spacing: 2) {
                            Text(event.title)
                                .font(.subheadline)
                            Text(" · ")
                                .font(.headline)
                            Text(event.value)
                                .font(.body.weight(.thin))
                        }

                        Spacer()
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }

    private func getMatchDetailsView(_ details: MatchDetailsModel) -> some View {
        VStack(spacing: 8) {
            Text(details.date)
                .font(.headline)
                .underline()

            ForEach(details.details) { detail in
                HStack(alignment: .firstTextBaseline) {
                    Text("\(detail.description):")
                        .font(.subheadline.weight(.medium))
                        .underline()
                    Text(detail.value)
                }
            }
        }
    }
}

#Preview {
    MatchDetailsView(matchId: "15e84040")
}
