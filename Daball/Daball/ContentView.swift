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
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }

    private var tabView: some View {
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
        .background(Color.element)
        .clipShape(Capsule())
        .padding(.horizontal, 26)
        .offset(y: 18)
    }
}

extension DaballTabView {
    func createTabItem(imageName: String, title: String, isActive: Bool, totalWidth: CGFloat) -> some View {
        if isActive {
            return HStack(spacing: 8) {
                Spacer()
                Image(systemName: imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(isActive ? Color.primary : Color.secondary)
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(isActive ? Color.primary : Color.secondary)
                Spacer()
            }
            .frame(width: totalWidth / 2.5, height: 44)
            .background(Color.tabBarBackground.opacity(0.5))
            .clipShape(Capsule())

        } else {
            return HStack(spacing: 8) {
                Spacer()
                Image(systemName: imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(isActive ? Color.primary : Color.secondary)
                    .frame(width: 24, height: 24)
            }
            .frame(width: 44, height: 44)
            .background(.clear)
        }
    }
}

#Preview {
    DaballTabView()
        .environmentObject(CompetitionsViewModel())
}
