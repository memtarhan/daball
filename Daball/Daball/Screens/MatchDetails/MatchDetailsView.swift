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
        NavigationStack {
            if viewModel.loading {
                ProgressView {
                    Text("Loading...")
                }

            } else {
                VStack {
                    if !viewModel.matchTeams.isEmpty {
                        VStack(spacing: 20) {
                            HStack(alignment: .center) {
                                homeTeamView
                                    .frame(minWidth: 0, maxWidth: .infinity)
//                                    .background(Color.yellow)

                                scoreView
//                                    .background(Color.green)

                                awayTeamView
                                    .frame(minWidth: 0, maxWidth: .infinity)
//                                    .background(Color.orange)
                            }
                            
                            if let details = viewModel.details {
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
}

#Preview {
    MatchDetailsView(matchId: "b839d4ce")
}
