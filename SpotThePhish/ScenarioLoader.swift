
//
//  ScenarioLoader.swift
//  SpotThePhish
//

import Foundation

// Matches the top-level JSON structure: { "scenarios": [...] }
private struct ScenarioFile: Decodable {
    let scenarios: [Scenario]
}

struct ScenarioLoader {

    // Load scenarios from a single JSON file in the app bundle
    static func load(filename: String) -> [Scenario] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("ScenarioLoader: \(filename).json not found in bundle")
            return []
        }
        guard let data = try? Data(contentsOf: url) else {
            print("ScenarioLoader: Could not read \(filename).json")
            return []
        }
        guard let file = try? JSONDecoder().decode(ScenarioFile.self, from: data) else {
            print("ScenarioLoader: Could not decode \(filename).json")
            return []
        }
        return file.scenarios
    }

    // Load scenarios for one specific category
    static func load(category: ScenarioCategory) -> [Scenario] {
        load(filename: category.filename)
    }

    // Load all scenarios from every category
    static func loadAll() -> [Scenario] {
        ScenarioCategory.allCases.flatMap { load(category: $0) }
    }
}
