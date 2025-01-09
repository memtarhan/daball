//
//  CompetitionsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct CompetitionRow: View {
    var competition: CompetitionModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: competition.logo)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "figure.soccer")
            }
            .frame(width: 36, height: 36)
            .padding(8)

            Text(competition.displayName)
                .font(.title2.weight(.light))
        }
    }
}

struct CompetitionsView: View {
    @EnvironmentObject var viewModel: CompetitionsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.competitions) { competition in
                    CompetitionRow(competition: competition)
                        .onTapGesture {
                            viewModel.selectedCompetition = competition
                            withAnimation(Animation.bouncy.delay(0.5)) {
                                dismiss()
                            }
                        }
                }
            }
            .navigationTitle("Competitions")
            .task {
                await viewModel.handleCompetitions()
            }
        }
    }
}

#Preview {
    CompetitionsView()
        .environmentObject(CompetitionsViewModel())
}
