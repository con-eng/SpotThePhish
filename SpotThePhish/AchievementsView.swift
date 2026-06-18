//
//  AchievementsView.swift
//  SpotThePhish
//
//  Created by Connor English on 6/14/26.
//

import SwiftUI

struct AchievementsView: View {
    @Environment(AchievementManager.self) private var achievementManager

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    progressHeader
                    ForEach(achievementManager.achievements) { achievement in
                        achievementRow(achievement)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Progress Header

    private var progressHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Text("\(achievementManager.unlockedCount) of \(achievementManager.achievements.count) Unlocked")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }

            GeometryReader { geo in
                let total   = achievementManager.achievements.count
                let fraction = total > 0
                    ? Double(achievementManager.unlockedCount) / Double(total)
                    : 0.0
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppTheme.cardSurface)
                        .frame(height: 8)
                    Capsule()
                        .fill(AppTheme.accentGradient)
                        .frame(width: geo.size.width * fraction, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(AppTheme.cardPadding)
        .cardStyle()
    }

    // MARK: - Achievement Row

    private func achievementRow(_ achievement: Achievement) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked
                          ? AppTheme.warning.opacity(0.2)
                          : AppTheme.cardSurface)
                    .frame(width: 50, height: 50)
                Image(systemName: achievement.iconName)
                    .font(.system(size: 22))
                    .foregroundColor(achievement.isUnlocked ? AppTheme.warning : AppTheme.textMuted)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(achievement.isUnlocked ? AppTheme.textPrimary : AppTheme.textMuted)
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                    .lineLimit(2)
                if achievement.isUnlocked, let date = achievement.unlockedDate {
                    Text("Unlocked \(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption2)
                        .foregroundColor(AppTheme.warning)
                }
            }

            Spacer()

            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AppTheme.success)
            }
        }
        .padding(AppTheme.cardPadding)
        .cardStyle()
        .opacity(achievement.isUnlocked ? 1.0 : 0.55)
    }
}
