//
//  Settings.swift
//  hp-trivia
//
//  Created by Matt Maher on 6/26/23.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) private var dismiss

    @State private var books: [BookStatus] = [
        .active, .active, .inactive,
        .locked, .locked, .locked,
        .locked
    ]

    var body: some View {
        ZStack {
            InfoBackgroundImage()

            VStack {
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)

                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(0 ..< books.count, id: \.self) { i in
                            SettingsBook(imageName: "hp\(i + 1)", status: $books[i])
                                .onTapGesture {
                                    if books[i] != .locked {
                                        books[i] = books[i] == .active ? .inactive : .active
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
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
