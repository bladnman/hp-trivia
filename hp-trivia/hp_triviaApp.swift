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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .task {
                    await store.loadProducts()
                }
        }
    }
}
