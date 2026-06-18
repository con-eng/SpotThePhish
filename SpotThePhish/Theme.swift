
//
//  Theme.swift
//  SpotThePhish
//

import SwiftUI

enum AppTheme {
    static let background      = Color(red: 0.04, green: 0.09, blue: 0.18)
    static let cardBackground  = Color(red: 0.08, green: 0.15, blue: 0.27)
    static let cardSurface     = Color(red: 0.11, green: 0.20, blue: 0.33)

    static let accent          = Color(red: 0.00, green: 0.84, blue: 1.00)
    static let accentSecondary = Color(red: 0.45, green: 0.30, blue: 1.00)

    static let success         = Color(red: 0.00, green: 0.80, blue: 0.45)
    static let danger          = Color(red: 1.00, green: 0.25, blue: 0.25)
    static let warning         = Color(red: 1.00, green: 0.65, blue: 0.00)

    static let textPrimary     = Color.white
    static let textSecondary   = Color(white: 0.65)
    static let textMuted       = Color(white: 0.40)

    static let headerGradient  = LinearGradient(
        colors: [Color(red: 0.04, green: 0.09, blue: 0.18), Color(red: 0.08, green: 0.17, blue: 0.32)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let accentGradient  = LinearGradient(
        colors: [accent, accentSecondary],
        startPoint: .leading, endPoint: .trailing
    )

    static let cornerRadius: CGFloat     = 16
    static let cardCornerRadius: CGFloat = 20
    static let buttonHeight: CGFloat     = 58
    static let cardPadding: CGFloat      = 20
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cardCornerRadius)
            .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 4)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: AppTheme.buttonHeight)
            .background(color.opacity(configuration.isPressed ? 0.75 : 1.0))
            .cornerRadius(AppTheme.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
