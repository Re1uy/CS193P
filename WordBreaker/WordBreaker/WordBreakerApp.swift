//
//  WordBreakerApp.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/16.
//

import SwiftUI
import SwiftData

@main
struct WordBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
        }
        .modelContainer(for: WordBreaker.self)
    }
}
