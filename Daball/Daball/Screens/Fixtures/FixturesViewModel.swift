//
//  FixturesViewModel.swift
//  Daball
//
//  Created by Mehmet Tarhan on 9.01.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct WeekModel: Identifiable, Equatable {
    let number: Int
    let description: String

    var id: Int {
        number
    }
}

struct ScoreModel: Identifiable {
    let homeTeam: String
    let awayTeam: String
    let homeTeamScore: String
    let awayTeamScore: String
    let timeDescription: String
    let venue: String?
    
    var id: String {
        homeTeam + awayTeam + timeDescription
    }
    
    var alreadyPlayed: Bool {
        homeTeamScore != "-" && awayTeamScore != "-"
    }
    var isHomeTeamWinner: Bool {
        homeTeamScore > awayTeamScore
    }
    
    //    static let sample = [
    //        ScoreModel(homeTeam: "Manchester Utd", awayTeam: "Fulham", homeTeamScore: "1", awayTeamScore: "2", date: "2024-08-16", time: "16:00"),
    //        ScoreModel(homeTeam: "Ipswich Town", awayTeam: "Liverpool", homeTeamScore: "2", awayTeamScore: "1", date: "2024-08-16", time: "20:00"),
    //        ScoreModel(homeTeam: "Newcastle Utd", awayTeam: "Southampton", homeTeamScore: "-", awayTeamScore: "-", date: "2024-08-17", time: "15:00"),
    //        ScoreModel(homeTeam: "Nott'ham Forest", awayTeam: "Bournemouth", homeTeamScore: "-", awayTeamScore: "-", date: "2024-08-18", time: "16:00"),
    //    ]
}

struct SectionedScoreModels: Identifiable {
    let section: String
    let scores: [ScoreModel]
    
    var id: String {
        section
    }
    
    static let sample = [
        SectionedScoreModels(
            section: "2024-08-16",
            scores: [
                ScoreModel(
                    homeTeam: "Manchester Utd",
                    awayTeam: "Fulham",
                    homeTeamScore: "1",
                    awayTeamScore: "2",
                    timeDescription: "Sat at 16:00",
                    venue: "Some stadium"
                ),
                ScoreModel(
                    homeTeam: "Ipswich Town",
                    awayTeam: "Liverpool",
                    homeTeamScore: "2",
                    awayTeamScore: "1",
                    timeDescription: "Sat at 20:00",
                    venue: "Some stadium"
                )
            ]
        ),
        SectionedScoreModels(
            section: "2024-08-17",
            scores: [ScoreModel(
                homeTeam: "Newcastle Utd",
                awayTeam: "Southampton",
                homeTeamScore: "-",
                awayTeamScore: "-",
                timeDescription: "Sun at 16:00",
                venue: "Some stadium"
            )]
        ),
        SectionedScoreModels(
            section: "2024-08-18",
            scores: [ScoreModel(
                homeTeam: "Nott'ham Forest",
                awayTeam: "Bournemouth",
                homeTeamScore: "-",
                awayTeamScore: "-",
                timeDescription: "Sat at 20:00",
                venue: "Some stadium"
            )]
        ),
    ]
}

@MainActor
class FixturesViewModel: ObservableObject, FixturesService {
    @Published var weeks: [WeekModel] = []
    @Published var selectedWeek: WeekModel? = nil
    @Published var scores: [SectionedScoreModels] = SectionedScoreModels.sample
    @Published var leagueTitle: String = ""
    @Published var loading: Bool = true
    @Published var expandedSections: [SectionedScoreModels] = []
    
    private var response: FixturesResponse?
    
    func reset(
        competitionId: Int
    ) {
        loading = true
        weeks
            .removeAll()
        scores
            .removeAll()
        selectedWeek = nil
        leagueTitle = ""
        
        Task {
            await handleFixtures(
                competitionId: competitionId
            )
        }
    }
    
    func handleSelectedWeeksFixture() {
        if let gameWeek = selectedWeek?.number,
           let fixture = response?.fixtures[gameWeek - 1] {
            scores
                .removeAll()
            
            let grouped = fixture.group(
                by: {
                    $0.date.date
                })
            scores = grouped
                .map { group in
                    let sectionTitle = group.first?.date.date
                    
                    let scores = group.map { scoreData in
                        let homeTeamScore = scoreData.homeTeamScore != nil ? "\(scoreData.homeTeamScore!)" : "-"
                        let awayTeamScore = scoreData.awayTeamScore != nil ? "\(scoreData.awayTeamScore!)" : "-"
                        
                        return ScoreModel(
                            homeTeam: scoreData.homeTeam,
                            awayTeam: scoreData.awayTeam,
                            homeTeamScore: homeTeamScore,
                            awayTeamScore: awayTeamScore,
                            timeDescription: "\(scoreData.date.dayOfWeek.rawValue.capitalized) at \(scoreData.date.startTime)",
                            venue: scoreData.venue
                        )
                    }
                    
                    return SectionedScoreModels(
                        section: sectionTitle ?? "Unknown",
                        scores: scores
                    )
                }
            
            expandedSections
                .removeAll()
            if let first = scores.first {
                expandedSections
                    .append(
                        first
                    )
            }
        }
    }
    
    func handleFixtures(
        competitionId: Int
    ) async {
        do {
            let response = try await getFixtures(
                competitionId: competitionId
            )
            self.response = response
            leagueTitle = response.leagueTitle
            weeks = response.fixtures
                .map { fixture in
                    let weekModel = WeekModel(
                        number: fixture.first?.gameWeek ?? -1,
                        description: "WEEK \(fixture.first?.gameWeek ?? -1)"
                    )
                    if fixture.first?.gameWeek == response.nextWeek {
                        selectedWeek = weekModel
                        
                        let grouped = fixture.group(
                            by: {
                                $0.date.date
                            })
                        scores = grouped
                            .map { group in
                                let sectionTitle = group.first?.date.date
                                
                                let scores = group.map { scoreData in
                                    let homeTeamScore = scoreData.homeTeamScore != nil ? "\(scoreData.homeTeamScore!)" : "-"
                                    let awayTeamScore = scoreData.awayTeamScore != nil ? "\(scoreData.awayTeamScore!)" : "-"
                                    
                                    return ScoreModel(
                                        homeTeam: scoreData.homeTeam,
                                        awayTeam: scoreData.awayTeam,
                                        homeTeamScore: homeTeamScore,
                                        awayTeamScore: awayTeamScore,
                                        timeDescription: "\(scoreData.date.dayOfWeek.rawValue.capitalized) at \(scoreData.date.startTime)",
                                        venue: scoreData.venue
                                    )
                                }
                                
                                return SectionedScoreModels(
                                    section: sectionTitle ?? "Unknown",
                                    scores: scores
                                )
                            }
                        
                        expandedSections
                            .removeAll()
                        if let first = scores.first {
                            expandedSections
                                .append(
                                    first
                                )
                        }
                    }
                    
                    return weekModel
                }
            
            loading = false
            
        } catch {
            print(
                error.localizedDescription
            )
            loading = false
        }
    }
}
