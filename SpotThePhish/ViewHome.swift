//
//  HomeView.swift
//  SpotThePhish
//

import SwiftUI

enum HomeDestination: Hashable {
    case play
    case statistics
    case achievements
    case about
}

struct HomeView: View {
    @Environment(StatisticsManager.self) private var statisticsManager
    @Environment(AchievementManager.self) private var achievementManager

    @State private var logoScale: CGFloat  = 0.8
    @State private var logoOpacity: Double = 0
    @State private var menuOffset: CGFloat = 40
    @State private var menuOpacity: Double = 0
    @State private var shieldRotation: Double = 0

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                dotGrid

                ScrollView {
                    VStack(spacing: 32) {
                        Spacer(minLength: 20)
                        logoSection
                        menuSection
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationBarHidden(true)
            .onAppear { animateIn() }
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .play:         GameView()
                case .statistics:   StatisticsView()
                case .achievements: AchievementsView()
                case .about:        AboutView()
                }
            }
        }
    }

    // MARK: - Background

    private var dotGrid: some View {
        Canvas { context, size in
            let spacing: CGFloat = 40
            let cols = Int(size.width  / spacing) + 2
            let rows = Int(size.height / spacing) + 2
            for col in 0..<cols {
                for row in 0..<rows {
                    let rect = CGRect(
                        x: CGFloat(col) * spacing - 1,
                        y: CGFloat(row) * spacing - 1,
                        width: 2, height: 2
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.04)))
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Logo

    private var logoSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppTheme.accent.opacity(0.12))
                    .frame(width: 120, height: 120)
                Circle()
                    .stroke(AppTheme.accent.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 120, height: 120)
                Image(systemName: "shield.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(AppTheme.accentGradient)
                    .rotationEffect(.degrees(shieldRotation))
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)

            VStack(spacing: 6) {
                Text("SPOT THE PHISH")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(AppTheme.accentGradient)
                    .tracking(2)
                Text("Cybersecurity Training")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                    .tracking(1)
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)

            if statisticsManager.statistics.totalQuestionsAnswered > 0 {
                HStack(spacing: 12) {
                    statPill(value: "\(statisticsManager.statistics.totalQuestionsAnswered)", label: "Played")
                    statPill(value: String(format: "%.1f%%", statisticsManager.statistics.accuracy), label: "Accuracy")
                    statPill(value: "\(statisticsManager.statistics.highestScore)", label: "Best Score")
                }
                .padding(.top, 4)
                .opacity(menuOpacity)
            }
        }
    }

    // MARK: - Menu

    private var menuSection: some View {
        VStack(spacing: 14) {
            NavigationLink(value: HomeDestination.play) {
                menuRow(icon: "gamecontroller.fill", title: "Play Now",
                        subtitle: "Start a new session", color: AppTheme.accent)
            }
            .buttonStyle(.plain)

            NavigationLink(value: HomeDestination.statistics) {
                menuRow(icon: "chart.bar.fill", title: "Statistics",
                        subtitle: "Track your progress", color: AppTheme.success)
            }
            .buttonStyle(.plain)

            NavigationLink(value: HomeDestination.achievements) {
                menuRow(icon: "trophy.fill", title: "Achievements",
                        subtitle: "\(achievementManager.unlockedCount)/\(achievementManager.achievements.count) unlocked",
                        color: AppTheme.warning)
            }
            .buttonStyle(.plain)

            NavigationLink(value: HomeDestination.about) {
                menuRow(icon: "info.circle.fill", title: "About Phishing",
                        subtitle: "Learn the warning signs",
                        color: Color(red: 0.55, green: 0.75, blue: 1.00))
            }
            .buttonStyle(.plain)
        }
        .offset(y: menuOffset)
        .opacity(menuOpacity)
    }

    private func menuRow(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.18))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppTheme.textMuted)
        }
        .padding(16)
        .cardStyle()
    }

    private func statPill(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.accent)
            Text(label)
                .font(.caption2)
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(AppTheme.cardBackground)
        .cornerRadius(10)
    }

    // MARK: - Animation

    private func animateIn() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.1)) {
            logoScale   = 1.0
            logoOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.55).delay(0.3)) {
            menuOffset  = 0
            menuOpacity = 1.0
        }
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            shieldRotation = 5
        }
    }
}
