
//
//  StatisticsViewModel.swift
//  SpotThePhish
//

import Foundation

@Observable
class StatisticsViewModel {

    private let manager: StatisticsManager

    init(manager: StatisticsManager) {
        self.manager = manager
    }

    var statistics: Statistics {
        manager.statistics
    }

    var sortedCategoryPerformance: [(category: String, stats: CategoryStats)] {
        manager.statistics.categoryStats
            .map { (category: $0.key, stats: $0.value) }
            .sorted { $0.stats.total > $1.stats.total }
    }
}

@Observable
class AchievementViewModel {

    private let manager: AchievementManager

    init(manager: AchievementManager) {
        self.manager = manager
    }

    var achievements: [Achievement]  { manager.achievements }
    var unlocked: [Achievement]      { manager.achievements.filter { $0.isUnlocked } }
    var locked: [Achievement]        { manager.achievements.filter { !$0.isUnlocked } }
    var unlockedCount: Int           { manager.unlockedCount }
    var totalCount: Int              { manager.achievements.count }

    var progressFraction: Double {
        guard totalCount > 0 else { return 0 }
        return Double(unlockedCount) / Double(totalCount)
    }
}
