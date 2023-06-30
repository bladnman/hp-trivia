//
//  SettingsBook.swift
//  hp-trivia
//
//  Created by Matt Maher on 6/26/23.
//

import SwiftUI



struct SettingsBook: View {
    var imageName: String
    @Binding var status: BookStatus

    var body: some View {
        let overlayOpacity = status == .locked ? 0.75 : status == .inactive ? 0.33 : 0
        return ZStack {
            ZStack(alignment: status == .locked ? .center : .bottomTrailing) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 7)
                    .overlay(Rectangle().opacity(overlayOpacity))

                BookIcon(state: $status)
            }
        }
    }
}

struct SettingsBook_Previews: PreviewProvider {
    static var previews: some View {
        SettingsBook(imageName: "hp6", status: .constant(.active))
    }
}

struct BookIcon: View {
    @Binding var state: BookStatus

    var body: some View {
        switch state {
        case .locked:
            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .imageScale(.large)
                .shadow(color: .white.opacity(0.75), radius: 3)
        case .inactive:
            Image(systemName: "circle")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundColor(.green.opacity(0.5))
                .shadow(radius: 1)
                .padding(3)
        case .active:
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundColor(.green)
                .shadow(radius: 1)
                .padding(3)
        }
    }
}
