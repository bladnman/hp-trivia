//
//  hp_triviaApp.swift
//  hp-trivia
//
//  Created by Matt Maher on 6/26/23.
//

import SwiftUI

@main
struct hp_triviaApp: App {
    @StateObject private var store = Store()
    @StateObject private var game = Game()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(game)
                .task {
                    await store.loadProducts()
                    game.loadScores()
                    store.loadStatus()
                }
        }
    }
}
