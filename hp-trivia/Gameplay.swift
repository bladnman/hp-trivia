//
//  Gameplay.swift
//  hp-trivia
//
//  Created by Matt Maher on 6/27/23.
//

import AVKit
import SwiftUI

struct Gameplay: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var game: Game
    @Namespace private var namespace
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var hintWiggle = false
    @State private var scaleNextButton = false
    @State private var movePointsToScore = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var tappedCorrectAnswer = false
    @State private var wrongAnswersTapped: [Int] = []

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
                            game.endGame()
                            dismiss()
                        } label: {
                            Text("End Game")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))

                        Spacer()

                        Text("Score: \(game.gameScore)")
                    }
                    .padding()
                    .padding(.vertical, 30)

                    // MARK: Question

                    VStack {
                        if animateViewsIn {
                            Text(game.currentQuestion.question)
                                .font(.custom(Constants.hpFont, size: 50))
                                .multilineTextAlignment(.center)
                                .transition(.scale)
                                .opacity(tappedCorrectAnswer ? 0.1 : 1)
                        }
                    }
                    .animation(.easeInOut(duration: animateViewsIn ? 2 : 0).delay(animateViewsIn ? 1 : 0), value: animateViewsIn)

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
                                    .rotationEffect(.degrees(hintWiggle ? -13 : -17))
                                    .padding()
                                    .transition(.offset(x: -geo.size.width / 2))
                                    .onAppear {
                                        withAnimation(
                                            .easeInOut(duration: 0.1)
                                                .repeatCount(9)
                                                .delay(5)
                                                .repeatForever())
                                        {
                                            hintWiggle = true
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)) {
                                            revealHint = true
                                        }
                                        playFlipSound()
                                        game.questionScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .opacity(revealHint ? 0 : 1)
                                    .offset(x: revealHint ? geo.size.width / 2 : 0)
                                    .overlay(
                                        Text(game.currentQuestion.hint)
                                            .padding(.leading, 33)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .opacity(revealHint ? 1 : 0)
                                            .scaleEffect(revealHint ? 1.33 : 0)
                                    )
                                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    .disabled(tappedCorrectAnswer)
                            }
                        }
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)

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
                                    .rotationEffect(.degrees(hintWiggle ? 13 : 17))
                                    .padding()

                                    .padding(.horizontal)
                                    .padding(.bottom)
                                    .transition(.offset(x: geo.size.width / 2))
                                    .onAppear {
                                        withAnimation(
                                            .easeInOut(duration: 0.1)
                                                .repeatCount(9)
                                                .delay(5)
                                                .repeatForever())
                                        {
                                            hintWiggle = true
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)) {
                                            revealBook = true
                                        }
                                        playFlipSound()
                                        game.questionScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealBook ? -1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealBook ? 5 : 1)
                                    .opacity(revealBook ? 0 : 1)
                                    .offset(x: revealBook ? -geo.size.width / 2 : 0)
                                    .overlay(
                                        Image("hp\(game.currentQuestion.book)")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(.trailing, 33)
                                            .opacity(revealBook ? 1 : 0)
                                            .scaleEffect(revealBook ? 1.0 : 0)
                                    )
                                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    .disabled(tappedCorrectAnswer)
                            }
                        }
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2.3 : 0), value: animateViewsIn)
                    }

                    // MARK: Answers

                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(Array(game.answers.enumerated()), id: \.offset) { i, answer in
                            if game.currentQuestion.answers[answer] == true {
                                VStack {
                                    if animateViewsIn && !tappedCorrectAnswer {
                                        Text(answer)
                                            .answerFont()
                                            .transition(.asymmetric(insertion: .scale,
                                                                    removal: .scale(scale: 5).combined(with:
                                                                        .opacity.animation(.easeOut(duration: 0.5)))))
                                            .matchedGeometryEffect(id: "answer", in: namespace)
                                    }
                                }
                                .animation(.easeOut(duration: 1).delay(1.5),
                                           value: animateViewsIn)
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 1)) {
                                        tappedCorrectAnswer = true
                                    }
                                    playCorrectSound()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                        game.correct()
                                    }
                                }
                            } else {
                                VStack {
                                    if animateViewsIn {
                                        Text(answer)
                                            .multilineTextAlignment(.center)
                                            .padding(10)
                                            .frame(width: UIScreen.main.bounds.width / 2.15, height: 80)
                                            .background(wrongAnswersTapped.contains(i) ? .red.opacity(0.5) : .green.opacity(0.5))
                                            .cornerRadius(15)
                                            .minimumScaleFactor(0.5)
                                            .transition(.scale)
                                            .onTapGesture {
                                                withAnimation(.easeOut(duration: 1)) {
                                                    withAnimation(.easeOut(duration: 1)) {
                                                        wrongAnswersTapped.append(i)
                                                    }
                                                }
                                                giveWrongFeedback()
                                                game.questionScore -= 1
                                                playWrongSound()
                                            }
                                            .scaleEffect(wrongAnswersTapped.contains(i) ? 0.8 : 1)
                                            .disabled(tappedCorrectAnswer || wrongAnswersTapped.contains(i))
                                            .opacity(tappedCorrectAnswer ? 0.1 : 1)
                                    }
                                }
                                .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0),
                                           value: animateViewsIn)
                            }
                        }
                    }

                    Spacer()
                }
                .frameFromScreen()
                .foregroundColor(.white)

                // MARK: Celebration

                VStack {
                    Spacer()

                    VStack {
                        if tappedCorrectAnswer {
                            Text("\(game.questionScore)")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .transition(.offset(y: -geo.size.height / 4))
                                .offset(x: movePointsToScore ? geo.size.width / 2.3 : 0,
                                        y: movePointsToScore ? -geo.size.height / 13 : 0)
                                .opacity(movePointsToScore ? 0 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1).delay(3)) {
                                        movePointsToScore = true
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut(duration: 1).delay(2), value: tappedCorrectAnswer)

                    Spacer()

                    VStack {
                        if tappedCorrectAnswer {
                            Text("Brilliant!")
                                .font(.custom(Constants.hpFont, size: 100))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height / 2)))
                        }
                    }
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0).delay(tappedCorrectAnswer ? 1 : 0), value: tappedCorrectAnswer)

                    Spacer()

                    if tappedCorrectAnswer {
                        Text(game.correctAnswer)
                            .answerFont()
                            .transition(.scale)
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: "answer", in: namespace)
                    }

                    Group {
                        Spacer()
                        Spacer()
                    }

                    VStack {
                        if tappedCorrectAnswer {
                            Button("Next Level>") {
                                animateViewsIn = false
                                tappedCorrectAnswer = false
                                revealBook = false
                                revealHint = false
                                movePointsToScore = false
                                wrongAnswersTapped = []
                                game.newQuestion()

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    animateViewsIn = true
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .font(.largeTitle)
                            .transition(.offset(y: geo.size.height / 3))
                            .scaleEffect(scaleNextButton ? 1.2 : 1)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                    scaleNextButton.toggle()
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 2.7 : 0).delay(tappedCorrectAnswer ? 2.7 : 0), value: tappedCorrectAnswer)

                    Group {
                        Spacer()
                        Spacer()
                    }
                }
                .foregroundColor(.white)
            }
            .frameFromScreen()
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                playMusic()
            }
        }
        .onDisappear {
            musicPlayer.pause()
        }
    }

    private func playMusic() {
        let songs = [
            "let-the-mystery-unfold",
            "spellcraft",
            "hiding-place-in-the-forest",
            "deep-in-the-dell",
        ]

        let i = Int.random(in: 0 ... 3)
        let sound = Bundle.main.path(forResource: songs[i], ofType: "mp3")

        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        musicPlayer.numberOfLoops = -1 // repeat forever
        musicPlayer.volume = 0.1
        musicPlayer.play()
    }

    private func playFlipSound() {
        playSFX("page-flip")
    }

    private func playWrongSound() {
        playSFX("negative-beeps")
    }

    private func playCorrectSound() {
        playSFX("magic-wand")
    }

    private func playSFX(_ resourceName: String) {
        let sound = Bundle.main.path(forResource: resourceName, ofType: "mp3")

        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }

    private func giveWrongFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

struct Gameplay_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Gameplay()
                .environmentObject(Game())
        }
    }
}
