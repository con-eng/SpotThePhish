//
//  AboutView.swift
//  SpotThePhish
//
//  Created by Connor English on 6/14/26.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    headerCard
                    infoCard(
                        title: "Warning Signs",
                        icon: "exclamationmark.triangle.fill",
                        color: AppTheme.danger,
                        items: [
                            ("Urgency and threats",        "Emails pushing you to act immediately or face consequences."),
                            ("Suspicious sender domains",  "Look-alike domains such as paypa1.com or chase-verify.net."),
                            ("Generic greetings",          "'Dear Customer' instead of your actual name."),
                            ("Unexpected links",           "Links that don't match the company's real website."),
                            ("Requests for personal info", "Legitimate companies never ask for passwords by email."),
                        ]
                    )
                    infoCard(
                        title: "What To Do",
                        icon: "checkmark.shield.fill",
                        color: AppTheme.success,
                        items: [
                            ("Don't click links",   "Go to the website by typing the address directly in your browser."),
                            ("Verify the sender",   "Check the full email address, not just the display name."),
                            ("Report it",           "Forward phishing emails to your IT team or email provider."),
                            ("Enable 2FA",          "Two-factor authentication protects you even if your password is stolen."),
                        ]
                    )
                }
                .padding(20)
            }
        }
        .navigationTitle("About Phishing")
        .navigationBarTitleDisplayMode(.large)
    }

    private var headerCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.shield.fill")
                .font(.system(size: 52))
                .foregroundStyle(AppTheme.accentGradient)

            Text("What is Phishing?")
                .font(.title2.bold())
                .foregroundColor(AppTheme.textPrimary)

            Text("Phishing is a cyberattack where criminals pretend to be trusted companies or people to steal your passwords, financial details, or personal information.")
                .font(.body)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(AppTheme.cardPadding)
        .cardStyle()
    }

    private func infoCard(title: String, icon: String, color: Color, items: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundColor(color)
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
            }

            ForEach(items, id: \.0) { heading, detail in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(color.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .padding(.top, 6)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(heading)
                            .font(.subheadline.bold())
                            .foregroundColor(AppTheme.textPrimary)
                        Text(detail)
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(3)
                    }
                }
            }
        }
        .padding(AppTheme.cardPadding)
        .cardStyle()
    }
}
