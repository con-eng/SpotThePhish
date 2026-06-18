
//
//  StatisticsManager.swift
//  SpotThePhish
//

import Foundation

@Observable
class StatisticsManager {

    private(set) var statistics: Statistics

    private let storageKey = "com.spotthephish.statistics"

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode(Statistics.self, from: data) {
            statistics = saved
        } else {
            statistics = Statistics()
        }
    }

    // Call this after every answer to update all stats
    func recordAnswer(correct: Bool, category: ScenarioCategory, score: Int) {
        statistics.totalQuestionsAnswered += 1

        if correct {
            statistics.correctAnswers += 1
            statistics.currentStreak += 1
            if statistics.currentStreak > statistics.bestStreak {
                statistics.bestStreak = statistics.currentStreak
            }
        } else {
            statistics.currentStreak = 0
        }

        // Update per-category stats
        var catStats = statistics.categoryStats[category.rawValue] ?? CategoryStats()
        catStats.total += 1
        if correct { catStats.correct += 1 }
        statistics.categoryStats[category.rawValue] = catStats

        // Track highest session score
        if score > statistics.highestScore {
            statistics.highestScore = score
        }

        save()
    }

    func reset() {
        statistics = Statistics()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(statistics) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
