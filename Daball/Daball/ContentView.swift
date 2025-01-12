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
            CurrentView()
                .tabItem {
                    Label("Current", systemImage: "timelapse")
                }
                .tag(0)
            StandingsView()
                .environmentObject(competitionsViewModel)
                .tabItem {
                    Label("Standings", systemImage: "table")
                }
                .tag(1)

            FixturesView()
                .environmentObject(competitionsViewModel)
                .tabItem {
                    Label("Fixtures", systemImage: "calendar")
                }
                .tag(2)
            
            StatsView()
                .environmentObject(competitionsViewModel)
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
