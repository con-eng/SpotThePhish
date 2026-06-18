
//
//  Statistics.swift
//  SpotThePhish
//

import Foundation

// Stats for a single category (e.g. Banking Scams)
struct CategoryStats: Codable {
    var correct: Int = 0
    var total: Int = 0

    // Accuracy as a percentage from 0 to 100
    var accuracy: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total) * 100
    }
}

// Overall stats saved across all sessions
struct Statistics: Codable {
    var totalQuestionsAnswered: Int = 0
    var correctAnswers: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var highestScore: Int = 0
    var categoryStats: [String: CategoryStats] = [:]

    // Accuracy as a percentage from 0 to 100
    var accuracy: Double {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestionsAnswered) * 100
    }
}
