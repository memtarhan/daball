//
//  FixturesView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct FixtureWeeksView: View {
    var data: [WeekModel]
    @Binding var selectedWeek: WeekModel?

    var body: some View {
        VStack {
            scrollView
            Divider()
        }
    }

    var scrollView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(data) { week in
                        Text(week.description)
                            .foregroundStyle(selectedWeek?.id == week.id ? Color.red : Color.primary)
                            .padding(12)
                            .onTapGesture {
                                selectedWeek = week
                                withAnimation {
                                    scrollProxy.scrollTo(week.id, anchor: .center)
                                }
                            }
                            .id(week.id)
                            .onAppear {
                                if selectedWeek != nil {
                                    withAnimation {
                                        scrollProxy.scrollTo(selectedWeek!.id, anchor: .center)
                                    }
                                }
                            }

                        Divider()
                    }
                }
            }
        }
    }
}

struct ScoreRow: View {
    var data: ScoreModel
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Text(data.homeTeam)
                    Spacer()
                    Text(data.homeTeamScore)
                }
                .font(getFontForHomeTeam(data))
                HStack {
                    Text(data.awayTeam)
                    Spacer()
                    Text(data.awayTeamScore)
                }
                .font(getFontForAwayTeam(data))
            }
            Text(data.time)
                .font(.caption)
                .padding(.top, 4)
        }
    }

    func getFontForHomeTeam(_ data: ScoreModel) -> Font {
        if data.alreadyPlayed {
            return data.isHomeTeamWinner ? Font.headline.weight(.medium) : Font.headline.weight(.thin)

        } else {
            return Font.headline.weight(.regular)
        }
    }

    func getFontForAwayTeam(_ data: ScoreModel) -> Font {
        if data.alreadyPlayed {
            return data.isHomeTeamWinner ? Font.headline.weight(.thin) : Font.headline.weight(.medium)

        } else {
            return Font.headline.weight(.regular)
        }
    }
}

struct ScoresView: View {
    var data: [SectionedScoreModels]
    @Binding var expandedSections: [SectionedScoreModels]

    var body: some View {
        List(data) { sectionData in
            Section(header: HStack {
                Image(systemName: "calendar.badge.clock")
                Text(sectionData.section)
                Spacer()
                Button {
                    if expandedSections.contains(where: { $0.section == sectionData.section }) {
                        expandedSections.removeAll(where: { $0.section == sectionData.section })
                        
                    } else {
                        expandedSections.append(sectionData)
                    }
                } label: {
                    Image(systemName: expandedSections.contains(where: { $0.section == sectionData.section }) ? "chevron.up" : "chevron.down")
                }
            }) {
                if expandedSections.contains(where: { $0.section == sectionData.section }) {
                    withAnimation(.easeInOut(duration: 1)) {
                        ForEach(sectionData.scores) { scoredata in
                            ScoreRow(data: scoredata)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct FixturesView: View {
    @StateObject private var viewModel = FixturesViewModel()
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel

    @State private var displayCompetitionsPopover: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                FixtureWeeksView(data: viewModel.weeks, selectedWeek: $viewModel.selectedWeek)
                    .frame(height: 36)

                ScoresView(data: viewModel.scores, expandedSections: $viewModel.expandedSections)
            }
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
            .task {
//                await viewModel.handleFixtures(competitionId: competitionsViewModel.selectedCompetition!.id)
            }
        }
        .onChange(of: competitionsViewModel.selectedCompetition) { _, newValue in
            if let competitionId = newValue?.id {
                viewModel.reset(competitionId: competitionId)
                displayCompetitionsPopover = false
            }
        }
        .onChange(of: viewModel.selectedWeek, { _, _ in
            viewModel.handleSelectedWeeksFixture()
        })
        .sheet(isPresented: $displayCompetitionsPopover) {
            CompetitionsView()
                .environmentObject(competitionsViewModel)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    FixturesView()
        .environmentObject(CompetitionsViewModel())
}
