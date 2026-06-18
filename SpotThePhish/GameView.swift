
//
//  GameView.swift
//  SpotThePhish
//

import SwiftUI

struct GameView: View {
    @Environment(StatisticsManager.self) private var statisticsManager
    @Environment(AchievementManager.self) private var achievementManager
    @State private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    init(category: ScenarioCategory? = nil) {
        _viewModel = State(wrappedValue: GameViewModel(category: category))
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            if viewModel.isGameOver {
                gameOverScreen
            } else if let scenario = viewModel.currentScenario {
                VStack(spacing: 0) {
                    header
                    progressBar
                    scenarioCard(scenario)
                        .frame(maxHeight: .infinity)
                    answerButtons
                }
            } else {
                // No scenarios were loaded (missing JSON files)
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundColor(AppTheme.warning)
                    Text("No scenarios found.\nCheck your JSON files.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(AppTheme.textSecondary)
                    Button("Go Back") { dismiss() }
                        .foregroundColor(AppTheme.accent)
                }
                .padding()
            }

            // Feedback overlay sits above everything
            if viewModel.showingFeedback, let scenario = viewModel.currentScenario {
                feedbackOverlay(scenario)
                    .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.2), value: viewModel.showingFeedback)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(10)
                    .background(AppTheme.cardBackground)
                    .clipShape(Circle())
            }

            Spacer()

            VStack(spacing: 2) {
                Text("Question \(viewModel.questionNumber) of \(viewModel.totalQuestions)")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                HStack(spacing: 3) {
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                        .foregroundColor(viewModel.streak > 0 ? AppTheme.warning : AppTheme.textMuted)
                    Text("\(viewModel.streak)")
                        .font(.caption.bold())
                        .foregroundColor(viewModel.streak > 0 ? AppTheme.warning : AppTheme.textMuted)
                }
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(AppTheme.accent)
                Text("\(viewModel.score)")
                    .font(.headline.bold())
                    .foregroundColor(AppTheme.accent)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppTheme.cardBackground)
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppTheme.cardBackground)
                    .frame(height: 6)
                Capsule()
                    .fill(AppTheme.accentGradient)
                    .frame(width: geo.size.width * viewModel.progress, height: 6)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.progress)
            }
        }
        .frame(height: 6)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Scenario Card

    private func scenarioCard(_ scenario: Scenario) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {

                // Category badge
                HStack(spacing: 6) {
                    Image(systemName: scenario.category.icon)
                        .font(.caption)
                    Text(scenario.category.rawValue)
                        .font(.caption.bold())
                }
                .foregroundColor(AppTheme.accent)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(AppTheme.accent.opacity(0.15))
                .cornerRadius(8)

                // Email fields
                emailRow(label: "From", value: scenario.from)
                Divider().background(AppTheme.textMuted.opacity(0.3))
                emailRow(label: "Subject", value: scenario.subject)
                Divider().background(AppTheme.textMuted.opacity(0.3))

                Text(scenario.body)
                    .font(.body)
                    .foregroundColor(AppTheme.textPrimary)
                    .lineSpacing(5)
            }
            .padding(AppTheme.cardPadding)
        }
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 20)
    }

    private func emailRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(label):")
                .font(.caption.bold())
                .foregroundColor(AppTheme.textMuted)
                .frame(width: 52, alignment: .leading)
            Text(value)
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
        }
    }

    // MARK: - Answer Buttons

    private var answerButtons: some View {
        VStack(spacing: 12) {
            Text("Is this a phishing attempt?")
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
                .padding(.top, 16)

            HStack(spacing: 12) {
                answerButton(title: "Phishing!", icon: "exclamationmark.shield.fill",
                             color: AppTheme.danger) { handleAnswer(true) }
                answerButton(title: "Legitimate", icon: "checkmark.shield.fill",
                             color: AppTheme.success) { handleAnswer(false) }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }

    private func answerButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 26))
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: AppTheme.buttonHeight)
            .background(color)
            .cornerRadius(AppTheme.cornerRadius)
        }
        .disabled(viewModel.showingFeedback)
    }

    // MARK: - Feedback Overlay

    private func feedbackOverlay(_ scenario: Scenario) -> some View {
        ZStack {
            Color.black.opacity(0.75).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    Image(systemName: viewModel.lastAnswerCorrect == true
                          ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(viewModel.lastAnswerCorrect == true
                                         ? AppTheme.success : AppTheme.danger)

                    Text(viewModel.lastAnswerCorrect == true ? "Correct!" : "Incorrect")
                        .font(.title.bold())
                        .foregroundColor(AppTheme.textPrimary)

                    // Explanation card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Explanation")
                            .font(.headline)
                            .foregroundColor(AppTheme.textPrimary)

                        Text(scenario.explanation)
                            .font(.body)
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(4)

                        if !scenario.redFlags.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Red Flags:")
                                    .font(.subheadline.bold())
                                    .foregroundColor(AppTheme.danger)

                                ForEach(scenario.redFlags, id: \.self) { flag in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "flag.fill")
                                            .font(.caption)
                                            .foregroundColor(AppTheme.danger)
                                            .padding(.top, 2)
                                        Text(flag)
                                            .font(.caption)
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(AppTheme.cardPadding)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(AppTheme.cardCornerRadius)

                    Button {
                        viewModel.next()
                    } label: {
                        Text(viewModel.isLastQuestion ? "See Results" : "Next Question")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppTheme.buttonHeight)
                            .background(AppTheme.accentGradient)
                            .cornerRadius(AppTheme.cornerRadius)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Game Over

    private var gameOverScreen: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                Image(systemName: "shield.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(AppTheme.accentGradient)

                Text("Session Complete!")
                    .font(.title.bold())
                    .foregroundColor(AppTheme.textPrimary)

                HStack(spacing: 12) {
                    resultCard(value: "\(viewModel.score)",
                               label: "Score", color: AppTheme.accent)
                    resultCard(value: "\(viewModel.correctCount)/\(viewModel.totalQuestions)",
                               label: "Correct", color: AppTheme.success)
                    resultCard(value: "\(viewModel.bestStreak)",
                               label: "Best Streak", color: AppTheme.warning)
                }

                let pct = Double(viewModel.correctCount) / Double(viewModel.totalQuestions) * 100

                VStack(spacing: 6) {
                    Text(gradeLabel(pct))
                        .font(.title2.bold())
                        .foregroundColor(gradeColor(pct))
                    Text(gradeMessage(pct))
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)

                Button { dismiss() } label: {
                    Text("Back to Home")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppTheme.buttonHeight)
                        .background(AppTheme.accentGradient)
                        .cornerRadius(AppTheme.cornerRadius)
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
    }

    private func resultCard(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .cardStyle()
    }

    private func gradeLabel(_ pct: Double) -> String {
        switch pct {
        case 90...100: return "⭐ Expert"
        case 70..<90:  return "🛡️ Defender"
        case 50..<70:  return "📚 Learning"
        default:       return "🎯 Keep Trying"
        }
    }

    private func gradeColor(_ pct: Double) -> Color {
        switch pct {
        case 90...100: return AppTheme.warning
        case 70..<90:  return AppTheme.success
        case 50..<70:  return AppTheme.accent
        default:       return AppTheme.textSecondary
        }
    }

    private func gradeMessage(_ pct: Double) -> String {
        switch pct {
        case 90...100: return "Outstanding! You're a phishing expert."
        case 70..<90:  return "Great job! You can spot most phishing attempts."
        case 50..<70:  return "Good effort. Keep practicing to improve."
        default:       return "Don't give up — every session helps you learn."
        }
    }

    // MARK: - Actions

    private func handleAnswer(_ isPhishing: Bool) {
        viewModel.answer(isPhishing: isPhishing)

        guard let correct = viewModel.lastAnswerCorrect,
              let scenario = viewModel.currentScenario else { return }

        statisticsManager.recordAnswer(correct: correct,
                                       category: scenario.category,
                                       score: viewModel.score)
        achievementManager.checkAchievements(statistics: statisticsManager.statistics,
                                             category: scenario.category)
    }
}
