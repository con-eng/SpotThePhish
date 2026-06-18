//
//  StatisticsView.swift
//  SpotThePhish
//
//  Created by Connor English on 6/14/26.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(StatisticsManager.self) private var statisticsManager

    var stats: Statistics { statisticsManager.statistics }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            if stats.totalQuestionsAnswered == 0 {
                emptyState
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        overallSection
                        if !stats.categoryStats.isEmpty {
                            categorySection
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.textMuted)
            Text("No stats yet")
                .font(.headline)
                .foregroundColor(AppTheme.textSecondary)
            Text("Play a session to see your progress here.")
                .font(.subheadline)
                .foregroundColor(AppTheme.textMuted)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Overall

    private var overallSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overall")
                .font(.headline)
                .foregroundColor(AppTheme.textSecondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                statCard(value: "\(stats.totalQuestionsAnswered)",
                         label: "Total Played", icon: "gamecontroller.fill", color: AppTheme.accent)
                statCard(value: String(format: "%.1f%%", stats.accuracy),
                         label: "Accuracy", icon: "target", color: AppTheme.success)
                statCard(value: "\(stats.bestStreak)",
                         label: "Best Streak", icon: "flame.fill", color: AppTheme.warning)
                statCard(value: "\(stats.highestScore)",
                         label: "High Score", icon: "star.fill", color: AppTheme.accentSecondary)
            }
        }
        .padding(AppTheme.cardPadding)
        .cardStyle()
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title2.bold())
                .foregroundColor(AppTheme.textPrimary)
            Text(label)
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppTheme.cardSurface)
        .cornerRadius(12)
    }

    // MARK: - By Category

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.headline)
                .foregroundColor(AppTheme.textSecondary)

            ForEach(ScenarioCategory.allCases) { category in
                if let catStats = stats.categoryStats[category.rawValue], catStats.total > 0 {
                    categoryRow(category: category, catStats: catStats)
                }
            }
        }
        .padding(AppTheme.cardPadding)
        .cardStyle()
    }

    private func categoryRow(category: ScenarioCategory, catStats: CategoryStats) -> some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .foregroundColor(AppTheme.accent)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(category.rawValue)
                        .font(.subheadline.bold())
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Text("\(catStats.correct)/\(catStats.total)")
                        .font(.caption.bold())
                        .foregroundColor(AppTheme.textSecondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AppTheme.cardSurface)
                            .frame(height: 6)
                        Capsule()
                            .fill(AppTheme.accentGradient)
                            .frame(width: geo.size.width * (catStats.accuracy / 100), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
    }
}
