
//
//  AchievementManager.swift
//  SpotThePhish
//

import Foundation

enum AchievementID: String, CaseIterable {
    case firstCatch         = "first_catch"
    case tenCorrect         = "ten_correct"
    case fiftyCorrect       = "fifty_correct"
    case hundredCorrect     = "hundred_correct"
    case streak5            = "streak_5"
    case streak10           = "streak_10"
    case perfectAccuracy    = "perfect_accuracy"
    case bankingExpert      = "banking_expert"
    case universityDefender = "university_defender"
    case socialHunter       = "social_hunter"
    case emailGuardian      = "email_guardian"
    case allCategories      = "all_categories"
}

@Observable
class AchievementManager {
    private(set) var achievements: [Achievement]
    var newlyUnlocked: Achievement? = nil

    private let userDefaultsKey = "com.spotthephish.achievements"

    init() {
        let defaults = AchievementManager.defaultAchievements()

        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let saved = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = defaults.map { def in
                if let match = saved.first(where: { $0.id == def.id }) {
                    return Achievement(
                        id: def.id,
                        title: def.title,
                        description: def.description,
                        iconName: def.iconName,
                        isUnlocked: match.isUnlocked,
                        unlockedDate: match.unlockedDate
                    )
                }
                return def
            }
        } else {
            achievements = defaults
        }
    }

    static func defaultAchievements() -> [Achievement] {
        [
            Achievement(id: AchievementID.firstCatch.rawValue,         title: "First Catch",               description: "Correctly identify your first phishing attempt",            iconName: "fish.fill"),
            Achievement(id: AchievementID.tenCorrect.rawValue,         title: "Sharp Eye",                 description: "Answer 10 questions correctly",                            iconName: "eye.fill"),
            Achievement(id: AchievementID.fiftyCorrect.rawValue,       title: "Phish Hunter",              description: "Answer 50 questions correctly",                            iconName: "scope"),
            Achievement(id: AchievementID.hundredCorrect.rawValue,     title: "Security Expert",           description: "Answer 100 questions correctly",                           iconName: "shield.fill"),
            Achievement(id: AchievementID.streak5.rawValue,            title: "On Fire 🔥",               description: "Get 5 correct answers in a row",                           iconName: "flame.fill"),
            Achievement(id: AchievementID.streak10.rawValue,           title: "Unstoppable",               description: "Get 10 correct answers in a row",                          iconName: "bolt.fill"),
            Achievement(id: AchievementID.perfectAccuracy.rawValue,    title: "Perfect Instincts",         description: "Answer 10+ questions correctly without a single mistake",   iconName: "star.fill"),
            Achievement(id: AchievementID.bankingExpert.rawValue,      title: "Banking Expert",            description: "Answer 5 banking scam questions correctly",                iconName: "banknote.fill"),
            Achievement(id: AchievementID.universityDefender.rawValue, title: "University Defender",       description: "Answer 5 university scam questions correctly",             iconName: "building.columns.fill"),
            Achievement(id: AchievementID.socialHunter.rawValue,       title: "Social Engineering Hunter", description: "Answer 5 social media scam questions correctly",           iconName: "person.2.fill"),
            Achievement(id: AchievementID.emailGuardian.rawValue,      title: "Email Guardian",            description: "Answer 5 email scam questions correctly",                  iconName: "envelope.fill"),
            Achievement(id: AchievementID.allCategories.rawValue,      title: "Versatile Defender",        description: "Answer at least one question in every category",           iconName: "globe"),
        ]
    }

    func checkAchievements(statistics: Statistics, category: ScenarioCategory) {
        var anyUnlocked = false

        for i in achievements.indices {
            guard !achievements[i].isUnlocked else { continue }
            guard let id = AchievementID(rawValue: achievements[i].id) else { continue }

            let shouldUnlock: Bool = {
                switch id {
                case .firstCatch:         return statistics.correctAnswers >= 1
                case .tenCorrect:         return statistics.correctAnswers >= 10
                case .fiftyCorrect:       return statistics.correctAnswers >= 50
                case .hundredCorrect:     return statistics.correctAnswers >= 100
                case .streak5:            return statistics.bestStreak >= 5
                case .streak10:           return statistics.bestStreak >= 10
                case .perfectAccuracy:    return statistics.accuracy >= 99.9 && statistics.totalQuestionsAnswered >= 10
                case .bankingExpert:      return (statistics.categoryStats[ScenarioCategory.bankingScams.rawValue]?.correct ?? 0) >= 5
                case .universityDefender: return (statistics.categoryStats[ScenarioCategory.university.rawValue]?.correct ?? 0) >= 5
                case .socialHunter:       return (statistics.categoryStats[ScenarioCategory.socialMedia.rawValue]?.correct ?? 0) >= 5
                case .emailGuardian:      return (statistics.categoryStats[ScenarioCategory.emailScams.rawValue]?.correct ?? 0) >= 5
                case .allCategories:
                    let played = ScenarioCategory.allCases.filter {
                        (statistics.categoryStats[$0.rawValue]?.total ?? 0) > 0
                    }.count
                    return played == ScenarioCategory.allCases.count
                }
            }()

            if shouldUnlock {
                achievements[i].isUnlocked = true
                achievements[i].unlockedDate = Date()
                newlyUnlocked = achievements[i]
                anyUnlocked = true
            }
        }

        if anyUnlocked { save() }
    }

    var unlockedCount: Int { achievements.filter { $0.isUnlocked }.count }

    func resetAll() {
        achievements = AchievementManager.defaultAchievements()
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
