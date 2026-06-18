
//
//  Achievement.swift
//  SpotThePhish
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    var isUnlocked: Bool = false
    var unlockedDate: Date? = nil
}
