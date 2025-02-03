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
                    Text(viewModel.title)
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

#Preview {
    MatchDetailsView(matchId: "ac04a5d2")
}
