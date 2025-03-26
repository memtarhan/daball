//
//  FootballStatsView.swift
//  Daball
//
//  Created by Mehmet Tarhan on 26.03.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import SwiftUI

struct FootballStatRow: View {
    var stat: FootballStatsItem

    var body: some View {
        HStack {
            Text(stat.player)
            Spacer()
            Text(stat.value, format: .number)
        }
    }
}

struct FootballStatsView: View {
    @Environment(FootballStatsModel.self) private var model

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(model.stats) { stat in
                        VStack {
                            Text(stat.title)
                            List {
                                ForEach(stat.items) { item in
                                    FootballStatRow(stat: item)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(model.title)
            .task {
                await model.fetch()
            }
        }
    }
}

#Preview {
    FootballStatsView()
}
