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

struct ScoresView: View {
    var data: [ScoreModel]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(data) { scoreModel in
                    VStack {
                        Text(scoreModel.date)
                        HStack {
                            Text(scoreModel.homeTeam)
                            Text(scoreModel.score)
                            Text(scoreModel.awayTeam)
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary, style: StrokeStyle(lineWidth: 1, dash: [10]))
                    )
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                }
            }
        }
    }
}

struct FixturesView: View {
    @StateObject private var viewModel = FixturesViewModel()
    @EnvironmentObject var competitionsViewModel: CompetitionsViewModel

    @State private var displayCompetitionsPopover: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                FixtureWeeksView(data: viewModel.weeks, selectedWeek: $viewModel.selectedWeek)
                    .frame(height: 36)

                ScoresView(data: viewModel.scores)
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
        .onChange(of: viewModel.selectedWeek, { oldValue, newValue in
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
