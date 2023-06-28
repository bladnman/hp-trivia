//
//  Constants.swift
//  hp-trivia
//
//  Created by Matt Maher on 6/26/23.
//

import Foundation
import SwiftUI

enum Constants {
    static let hpFont = "PartyLetPlain"
}

struct InfoBackgroundImage: View {
    var body: some View {
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

extension Button {
    func doneButton() -> some View {
        self
            .font(.largeTitle)
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundColor(.white)
    }
}

extension View {
    func frameFromScreen(widthScale: CGFloat? = 1.0, heightScale: CGFloat? = 1.0) -> some View {
        self.frame(
            width: (widthScale ?? 1.0) * UIScreen.main.bounds.width,
            height: (heightScale ?? 1.0) * UIScreen.main.bounds.height
        )
    }
}
