//
//  ContentView.swift
//  SpotThePhish
//
//  Not used by the app directly — kept for Xcode previews.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

#Preview {
    ContentView()
        .environment(StatisticsManager())
        .environment(AchievementManager())
}
