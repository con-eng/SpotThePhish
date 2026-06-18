
//
//  Scenario.swift
//  SpotThePhish
//

import Foundation

struct Scenario: Identifiable, Codable {
    let id: String
    let category: ScenarioCategory
    let from: String
    let subject: String
    let body: String
    let isPhishing: Bool
    let explanation: String
    let redFlags: [String]
}
