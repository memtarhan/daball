//
//  ContentView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel

    var body: some View {
        TabView {
            StandingsView()
                .environmentObject(competitionsViewModel)
                .tabItem {
                    Label("Standings", systemImage: "table")
                }
                .tag(0)

            FixturesView()
                .environmentObject(competitionsViewModel)
                .tabItem {
                    Label("Fixtures", systemImage: "calendar")
                }
                .tag(1)
            
            StatsView()
                .environmentObject(competitionsViewModel)
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
