//
//  Gameplay.swift
//  hp-trivia
//
//  Created by Matt Maher on 6/27/23.
//

import SwiftUI

struct Gameplay: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animateViewsIn = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("hogwarts")
                    .resizable()
                    .frameFromScreen(widthScale: 3, heightScale: 1.05)
                    .overlay(Rectangle().foregroundColor(.black.opacity(0.8)))

                VStack {
                    // MARK: Controls
                    HStack {
                        Button {
                            // TODO: end game
                            dismiss()
                        } label: {
                            Text("End Game")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))

                        Spacer()

                        Text("Score: 33")
                    }
                    .padding()
                    .padding(.vertical, 30)

                    // MARK: Question
                    VStack {
                        if animateViewsIn {
                            Text("Who is Harry Potter")
                                .font(.custom(Constants.hpFont, size: 50))
                                .multilineTextAlignment(.center)
                                .transition(.scale)
                        }
                    }
                    .animation(.easeInOut(duration: 2), value: animateViewsIn)

                    Spacer()

                    // MARK: Hints
                    HStack {
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundColor(.cyan)
                                    .rotationEffect(.degrees(-15))
                                    .padding()
                                    .transition(.offset(x: -geo.size.width / 2))
                            }
                        }
                        .animation(.easeOut(duration: 1.5).delay(2), value: animateViewsIn)

                        Spacer()

                        VStack {
                            if animateViewsIn {
                                Image(systemName: "book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundColor(.black)
                                    .frame(width: 100, height: 100)
                                    .background(.cyan)
                                    .cornerRadius(20)
                                    .rotationEffect(.degrees(15))
                                    .padding()

                                    .padding(.horizontal)
                                    .padding(.bottom)
                                    .transition(.offset(x: geo.size.width / 2))
                            }
                        }
                        .animation(.easeOut(duration: 1.5).delay(2.3), value: animateViewsIn)
                    }

                    // MARK: Answers
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(1 ..< 5) { i in
                            VStack {
                                if animateViewsIn {
                                    Text("Answer \(i)")
                                        .multilineTextAlignment(.center)
                                        .padding(10)
                                        .frame(width: geo.size.width / 2.15, height: 80)
                                        .background(.green.opacity(0.5))
                                        .cornerRadius(15)
                                        .minimumScaleFactor(0.5)
                                        .transition(.scale)
                                }
                            }
                            .animation(.easeOut(duration: 1).delay(1.5),
                                       value: animateViewsIn)
                        }
                    }

                    Spacer()
                }
                .frameFromScreen()
                .foregroundColor(.white)
            }
            .frameFromScreen()
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
        }
    }
}

struct Gameplay_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Gameplay()
        }
    }
}
