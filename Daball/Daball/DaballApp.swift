//
//  DaballApp.swift
//  Daball
//
//  Created by Mehmet Tarhan on 8.01.2025.
//

import SwiftUI

@main
struct DaballApp: App {
    @StateObject var competitionsViewModel: CompetitionsViewModel = CompetitionsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(competitionsViewModel)
        }
    }
}
