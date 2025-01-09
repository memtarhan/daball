//
//  FixturesView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct FixturesView: View {
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel
    
    @State private var displayCompetitionsPopover: Bool = false

    
    
    var body: some View {
        NavigationStack {
            Text("Hello, World!")
                .navigationTitle(competitionsViewModel.selectedCompetition?.displayName ?? "...")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button {
                            displayCompetitionsPopover = true
                        } label: {
                            Image(systemName: displayCompetitionsPopover ? "chevron.up" : "chevron.down")
                        }
                    }
                }
        }
        .onChange(of: competitionsViewModel.selectedCompetition) { _, newValue in
            if let competitionId = newValue?.id {
//                viewModel.reset(competitionId: competitionId)
//                displayCompetitionsPopover = false
            }
        }
        .sheet(isPresented: $displayCompetitionsPopover) {
            CompetitionsView()
                .environmentObject(competitionsViewModel)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    FixturesView()
}
