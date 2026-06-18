
//
//  Scenarios.swift
//  SpotThePhish
//

import SwiftUI

enum ScenarioCategory: String, CaseIterable, Codable, Identifiable {
    case bankingScams = "Banking Scams"
    case emailScams   = "Email Scams"
    case socialMedia  = "Social Media"
    case university   = "University"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .bankingScams: return "banknote.fill"
        case .emailScams:   return "envelope.fill"
        case .socialMedia:  return "person.2.fill"
        case .university:   return "building.columns.fill"
        }
    }

    // The JSON filename (without .json extension) for this category
    var filename: String {
        switch self {
        case .bankingScams: return "banking"
        case .emailScams:   return "email"
        case .socialMedia:  return "socialmedia"
        case .university:   return "university"
        }
    }
}
