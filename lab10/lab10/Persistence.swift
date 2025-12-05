//
//  Persistence.swift
//  lab10
//
//  Created by Aisana Ondassyn on 05.12.2025.
//


import Foundation

enum Persistence {
    private static let lastHeroKey = "lastHeroID_v1"

    static func saveLastHeroID(_ id: Int) {
        UserDefaults.standard.set(id, forKey: lastHeroKey)
    }

    static func loadLastHeroID() -> Int? {
        let id = UserDefaults.standard.integer(forKey: lastHeroKey)
        if UserDefaults.standard.object(forKey: lastHeroKey) == nil {
            return nil
        }
        return id
    }

    static func clearLastHero() {
        UserDefaults.standard.removeObject(forKey: lastHeroKey)
    }
}
