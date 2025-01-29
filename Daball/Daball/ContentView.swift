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
                    .toolbarBackground(Color.systemBackground, for: .tabBar)
                StandingsView()
                    .environmentObject(competitionsViewModel)
                    .tag(1)
                    .toolbarBackground(Color.systemBackground, for: .tabBar)

                FixturesView()
                    .environmentObject(competitionsViewModel)
                    .tag(2)
                    .toolbarBackground(Color.systemBackground, for: .tabBar)

                StatsView()
                    .environmentObject(competitionsViewModel)
                    .tag(3)
                    .toolbarBackground(Color.systemBackground, for: .tabBar)
            }
            ZStack {
                GeometryReader { proxy in

                    HStack {
                        ForEach(TabItem.allCases, id: \.self) { item in
                            Button {
                                withAnimation(.easeInOut) {
                                    selectedTab = item.rawValue
                                }
                            } label: {
                                createTabItem(imageName: item.iconName,
                                              title: item.title,
                                              isActive: selectedTab == item.rawValue,
                                              totalWidth: proxy.size.width)
                            }
                        }
                    }
                    .offset(y: 10)
                }
                .padding(.horizontal, 6)
            }
            .frame(height: 64, alignment: .bottom)
            .background(Color.tabBarBackground.opacity(0.25))
            .clipShape(Capsule())
            .padding(.horizontal, 26)
            .offset(y: 18)
        }
    }
}

extension DaballTabView {
    func createTabItem(imageName: String, title: String, isActive: Bool, totalWidth: CGFloat) -> some View {
        HStack(spacing: 10) {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? Color.primary : Color.secondary)
                .frame(width: 18, height: 18)
            if isActive {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(isActive ? Color.primary : Color.secondary)
            }
            Spacer()
        }
        .frame(width: isActive ? totalWidth / 2.5 : 44, height: 44)
        .background(isActive ? Color.tabBarBackground.opacity(0.5) : .clear)
        .clipShape(Capsule())
    }
}


#Preview {
    DaballTabView()
        .environmentObject(CompetitionsViewModel())
}
