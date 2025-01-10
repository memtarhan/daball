//
//  CompetitionsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct CompetitionLogoView: View {
    var url: String
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "figure.soccer")
        }
        .frame(width: 36, height: 36)
        .padding(8)
    }
}

struct CompetitionRow: View {
    var competition: CompetitionModel

    var body: some View {
        HStack {
            CompetitionLogoView(url: competition.logo)
            Text(competition.displayName)
                .font(.title3.weight(.light))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.primary.opacity(0.5))
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
