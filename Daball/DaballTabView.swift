//
//  DaballTabView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//

import SwiftUI

struct DaballTabView: View {
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel

    @State var selectedTab = 0

    var body: some View {
        TabView {
            CurrentView()
                .tag(0)
                .tabItem {
                    Label("Current", systemImage: "timelapse")
                }

            StandingsView()
                .environmentObject(competitionsViewModel)
                .tag(1)
                .tabItem {
                    Label("Menu", systemImage: "table")
                }

            FixturesView()
                .environmentObject(competitionsViewModel)
                .tag(2)
                .tabItem {
                    Label("Menu", systemImage: "calendar")
                }

            StatsView()
                .environmentObject(competitionsViewModel)
                .tag(3)
                .tabItem {
                    Label("Menu", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

#Preview {
    DaballTabView()
        .environmentObject(CompetitionsViewModel())
}
