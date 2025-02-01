//
//  ContentView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//

import SwiftUI

struct DaballTabView: View {
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel

    @State var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                CurrentView()
                    .tag(0)
                    .toolbarBackground(Color.clear, for: .tabBar)
                StandingsView()
                    .environmentObject(competitionsViewModel)
                    .tag(1)
                    .toolbarBackground(Color.clear, for: .tabBar)

                FixturesView()
                    .environmentObject(competitionsViewModel)
                    .tag(2)
                    .toolbarBackground(Color.clear, for: .tabBar)

                StatsView()
                    .environmentObject(competitionsViewModel)
                    .tag(3)
                    .toolbarBackground(Color.clear, for: .tabBar)
            }
            ZStack {
                shadowView
                tabView
            }
        }
    }

    private var shadowView: some View {
        Capsule()
            .fill(Color.element)
            .frame(height: 64, alignment: .bottom)
            .padding(.horizontal, 26)
            .offset(y: 18)
            .shadow(color: Color.systemBackground.opacity(1), radius: 10, x: 10, y: 10)
            .shadow(color: Color.systemBackground.opacity(0.1), radius: 10, x: -15, y: -15)
    }

    private var tabView: some View {
        ZStack {
            HStack(alignment: .center, spacing: 8) {
                ForEach(TabItem.allCases, id: \.self) { item in
                    Button {
                        withAnimation(.easeInOut) {
                            selectedTab = item.rawValue
                        }
                    } label: {
                        Image(systemName: item.iconName)
                            .foregroundColor(.white)

                    }
                    .buttonStyle(ColorfulButtonStyle(isPressed: selectedTab == item.rawValue))
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .offset(y: -6)
            .padding(.horizontal, 6)
        }
        .frame(height: 64, alignment: .bottom)
        .background(Color.element)
        .clipShape(Capsule())
        .padding(.horizontal, 26)
        .offset(y: 18)
    }
}

#Preview {
    DaballTabView()
        .environmentObject(CompetitionsViewModel())
}
