
//
//  GameViewModel.swift
//  SpotThePhish
//

import Foundation

@Observable
class GameViewModel {

    // MARK: - State

    private(set) var currentIndex: Int = 0
    private(set) var score: Int = 0
    private(set) var streak: Int = 0
    private(set) var bestStreak: Int = 0
    private(set) var correctCount: Int = 0
    private(set) var lastAnswerCorrect: Bool? = nil
    private(set) var showingFeedback: Bool = false
    private(set) var isGameOver: Bool = false

    let totalQuestions = 10
    private(set) var scenarios: [Scenario] = []

    // MARK: - Computed

    var currentScenario: Scenario? {
        guard currentIndex < scenarios.count else { return nil }
        return scenarios[currentIndex]
    }

    // 0.0 to 1.0 — used for the progress bar
    var progress: Double {
        Double(currentIndex) / Double(totalQuestions)
    }

    var questionNumber: Int { currentIndex + 1 }

    var isLastQuestion: Bool {
        currentIndex >= totalQuestions - 1 || currentIndex >= scenarios.count - 1
    }

    // MARK: - Init

    init(category: ScenarioCategory? = nil) {
        let pool = category == nil ? ScenarioLoader.loadAll() : ScenarioLoader.load(category: category!)
        scenarios = Array(pool.shuffled().prefix(totalQuestions))
    }

    // MARK: - Game Logic

    func answer(isPhishing: Bool) {
        // Prevent answering twice on the same question
        guard let scenario = currentScenario, !showingFeedback else { return }

        let correct = isPhishing == scenario.isPhishing
        lastAnswerCorrect = correct
        showingFeedback = true

        if correct {
            streak += 1
            bestStreak = max(bestStreak, streak)
            correctCount += 1
            // Streak bonus: +2 points for every consecutive correct answer
            let bonus = (streak - 1) * 2
            score += 10 + bonus
        } else {
            streak = 0
        }
    }

    func next() {
        showingFeedback = false
        lastAnswerCorrect = nil

        if isLastQuestion {
            isGameOver = true
        } else {
            currentIndex += 1
        }
    }
}
