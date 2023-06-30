//
//  Settings.swift
//  hp-trivia
//
//  Created by Matt Maher on 6/26/23.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: Store

    var body: some View {
        ZStack {
            InfoBackgroundImage()

            VStack {
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)

                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(0 ..< store.books.count, id: \.self) { i in
                            var bookStatus = store.books[i]

                            // check for active or purchased books
                            if store.books[i] == .active || store.purchasedIDs.contains("hp\(i + 1)") {
                                SettingsBook(imageName: "hp\(i + 1)", status: $store.books[i])
                                    .onTapGesture {
                                        // we already know it's an active/purchased book, just toggle
                                        store.books[i] = store.books[i] == .active ? .inactive : .active
                                    }
                                    .task {
                                        // make it actually active
                                        store.books[i] = .active
                                    }
                            }
                            // all books here are locked
                            else {
                                SettingsBook(imageName: "hp\(i + 1)", status: $store.books[i])
                                    .onTapGesture {
                                        // PURCHASE
                                        if store.books[i] == .locked {
                                            // remember, products don't include the first 3 books
                                            let product = store.products[i - 3]
                                            Task {
                                                await store.purchase(product)
                                            }
                                        }

                                        // TOGGLE
                                        else {
                                            store.books[i] = store.books[i] == .active ? .inactive : .active
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                }

                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
                .doneButton()
            }
        }
        .preferredColorScheme(.light)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(Store())
    }
}
