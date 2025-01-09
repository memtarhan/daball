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
    @StateObject private var viewModel = CompetitionsViewModel()
    
    @Binding var selectedCompetitionId: Int
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.competitions) { competition in
                    CompetitionRow(competition: competition)
                        .onTapGesture {
                            selectedCompetitionId = competition.id
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
    CompetitionsView(selectedCompetitionId: .constant(9))
}
