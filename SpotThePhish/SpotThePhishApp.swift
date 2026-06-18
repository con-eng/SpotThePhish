//
//  SpotThePhishApp.swift
//  SpotThePhish
//

import SwiftUI

@main
struct SpotThePhishApp: App {

    @State private var statisticsManager = StatisticsManager()
    @State private var achievementManager = AchievementManager()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(statisticsManager)
                .environment(achievementManager)
                .preferredColorScheme(.dark)
        }
    }
}
