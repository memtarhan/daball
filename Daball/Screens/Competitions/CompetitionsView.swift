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
        VStack(spacing: 0) {
            HStack {
                CompetitionLogoView(url: competition.logo)
                Text(competition.displayName)
                    .font(.subheadline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.primary.opacity(0.5))
            }

            Divider()
        }
        .padding(.horizontal, 32)
    }
}

struct CompetitionsView: View {
    @EnvironmentObject var viewModel: CompetitionsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.8), .blue.opacity(0.6), .blue.opacity(0.4), .blue.opacity(0.2), .blue.opacity(0)]), startPoint: .trailing, endPoint: .leading)
                    .ignoresSafeArea(.all)

                ScrollView {
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
            }
            .navigationTitle("Select a Competition")
            .navigationBarTitleDisplayMode(.inline)
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
