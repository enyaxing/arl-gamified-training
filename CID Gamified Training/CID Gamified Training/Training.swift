
//
//  Training.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI
import Darwin
import Firebase

/** Training game. */
struct Training: View {

    /** Show summary view. */
    @State var summary = false

    /** Stars. */
    @State var points: Int

    /** List of answers. */
    @State var answers: [Answer] = []

    /** Show countdown. */
    @Binding var countdown: Bool

    /** Records the start of the session */
    var startTimestamp = Timestamp()
    
    var body: some View {
        Group {
            if self.summary {
                Summary(answers: answers, countdown: $countdown, session: Session(points: self.points, timestamp: self.startTimestamp, type: "Forced Choice"))
            } else {
                TrainingMain(summary: $summary, answers: $answers, points: $points)
                .onDisappear{
                    if !self.summary {
                        self.countdown = true
                    }
                }
            }
        }
    }
}

/** Main training game view. */
struct TrainingMain: View {

    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser

    /** Keeps track of which question we are on.. */
    @State var questionCount: Int = 0

    /** Boolean to show if the training game has ended. */
    @State var stopped = false

    /** Boolean to show ending alert. */
    @State var alert = false

    /** When to show feedback. */
    @State var feedback = false

    /** Is question correct? */
    @State var correct = true

    /** Show summary. */
    @Binding var summary: Bool

    /** List of answers. */
    @Binding var answers: [Answer]

    /** Points. */
    @Binding var points: Int

    /** List of pictures grouped by friendly or foe. */
    let models = [Model.friendly, Model.foe]

    /** Friendly or foe folder selector.  0=friendly, 1=foe*/
    @State var folder = Int.random(in: 0...1)

    /** Index to keep track of which picture is shown. 1==friendly 2 == foe*/
    @State var index = 0

    /** Stopwatch. */
    @ObservedObject var stopWatchManager = StopWatchManager()

    /** To close the view. */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /** How much is considered to be full score. */
    let fullPointVal: Int = 50

    /** Back button view. */
    var btnBack : some View {
        Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
            Image("close")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                btnBack
                ZStack {
                    ProgressBar(value: $questionCount)
                        .padding(.horizontal)
                        .padding(.vertical, 10.0)
                    Text("\(questionCount) / 20")
                        .font(.headline)
                        .foregroundColor(Color.white)
                }

                if self.user.regular != "neutral" {
                    Text("\(self.points)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    Image("coin").resizable().frame(width: 40, height: 40)
                        .aspectRatio(contentMode: .fit)
                        .offset(y: -2)
                }
            }
            .padding(.top, 30.0)
            .padding(.horizontal, 30.0)
            .frame(height: 50.0)
            Spacer()
            Group {
                if self.feedback || self.stopped {
                    if self.correct {
                        if self.user.regular == "promotion" {
                            Promotion(secondsElapsed: stopWatchManager.secondsElapsed, points: fullPointVal + calculateTimeScore(timeElapsed: stopWatchManager.secondsElapsed), type: "correct", multiply: false, playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        } else if self.user.regular == "prevention" {
                            Prevention(secondsElapsed: stopWatchManager.secondsElapsed, points: fullPointVal - calculateTimeScore(timeElapsed: stopWatchManager.secondsElapsed), type: "correct", multiply: false, playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        } else {
                            Neutral(secondsElapsed: stopWatchManager.secondsElapsed, type: "correct", playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        }
                    } else {
                        if self.user.regular == "promotion" {
                            Promotion(secondsElapsed: stopWatchManager.secondsElapsed, points: 0, type: "incorrect", multiply: false, playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        } else if self.user.regular == "prevention" {
                            Prevention(secondsElapsed: stopWatchManager.secondsElapsed, points: 2 * fullPointVal, type: "incorrect", multiply: false, playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        } else {
                            Neutral(secondsElapsed: stopWatchManager.secondsElapsed, type: "incorrect", playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        }
                    }
                } else {
                    Image(uiImage: UIImage(imageLiteralResourceName: models[self.folder][self.index].imageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 30.0)
                        .onAppear {
                            self.stopWatchManager.start()
                        }
                }
            }.frame(width: 400, height: 400)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.friendlyButtonAction()
                }) {
                    Text("FRIENDLY")
                }
                .buttonStyle(FriendlyButtonStyle())
                Spacer()
                Button(action: {
                    self.enemyActionButton()
                }) {
                    Text("ENEMY")
                }
                .buttonStyle(EnemyButtonStyle())
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .alert(isPresented: $alert) {
            if (self.user.regular == "neutral") {
                return Alert(title: Text("Congratulations!"), message: Text("You have made it to the end of the training."), dismissButton: .default(Text("Session Summary"), action: {
                    self.alert = false
                    self.summary = true
                })
                )
            } else {
                return Alert(title: Text("Congratulations!"), message: Text("You have made it to the end of the training. Your final score is \(points)."), dismissButton: .default(Text("Session Summary"), action: {
                    self.alert = false
                    self.summary = true
                }))
            }
        }
        .onAppear() {
            self.index = Int.random(in: 0..<self.models[self.folder].count)
        }.background(Color.lightBlack.edgesIgnoringSafeArea(.all))
    }

    /** Action performed when friendly button clicked. */
    func friendlyButtonAction() -> () {
        if !self.stopped && !self.feedback {
            if self.folder == 0 {
                if self.user.regular == "promotion" || self.user.regular == "neutral"{
                    self.points += fullPointVal
                    self.points += calculateTimeScore(timeElapsed: stopWatchManager.secondsElapsed)
                } else if self.user.regular == "prevention" {
                    self.points -= fullPointVal - calculateTimeScore(timeElapsed: stopWatchManager.secondsElapsed)
                }
                self.correct = true
                self.answers.append(Answer(id: self.answers.count,
                                           expected: "friendly",
                                           received: "friendly",
                                           image: self.models[self.folder][self.index].imageURL,
                                           vehicleName: self.models[self.folder][self.index].vehicleName,
                                           time: stopWatchManager.secondsElapsed))
            } else {
                if self.user.regular == "prevention" {
                    self.points -= 2 * fullPointVal
                }
                self.correct = false
                self.answers.append(Answer(id: self.answers.count,
                                           expected: "foe",
                                           received: "friendly",
                                           image: self.models[self.folder][self.index].imageURL,
                                           vehicleName: self.models[self.folder][self.index].vehicleName,
                                           time: stopWatchManager.secondsElapsed))
            }
            self.folder = Int.random(in: 0...1)
            self.index = Int.random(in: 0..<self.models[self.folder].count)
            self.feedback = true
            if self.questionCount == 19 {
                self.stopped = true
                self.alert = true
            }
            self.questionCount += 1
        }
    }

    /** Action performed when enemy button clicked. */
    func enemyActionButton() -> () {
        if !self.stopped && !self.feedback {
            if self.folder == 1 {
                if self.user.regular == "promotion" || self.user.regular == "neutral" {
                    self.points += fullPointVal
                    self.points += calculateTimeScore(timeElapsed: stopWatchManager.secondsElapsed)
                } else if self.user.regular == "prevention" {
                    self.points -= fullPointVal - calculateTimeScore(timeElapsed: stopWatchManager.secondsElapsed)
                }
                self.correct = true
                self.answers.append(Answer(id: self.answers.count,
                                           expected: "foe",
                                           received: "foe",
                                           image: self.models[self.folder][self.index].imageURL,
                                           vehicleName: self.models[self.folder][self.index].vehicleName,
                                           time: stopWatchManager.secondsElapsed))
            } else {
                if self.user.regular == "prevention" {
                    self.points -= 2 * fullPointVal
                }
                self.correct = false
                self.answers.append(Answer(id: self.answers.count,
                                           expected: "friendly",
                                           received: "foe",
                                           image: self.models[self.folder][self.index].imageURL,
                                           vehicleName: self.models[self.folder][self.index].vehicleName,
                                           time: stopWatchManager.secondsElapsed))
            }
            self.folder = Int.random(in: 0...1)
            self.index = Int.random(in: 0..<self.models[self.folder].count)
            self.feedback = true
            if self.questionCount == 19 {
                self.stopped = true
                self.alert = true
            }
            self.questionCount += 1
        }
    }

    /** Calculates the score, out of 50 based on response time. */
    func calculateTimeScore(timeElapsed: Double) -> Int {
        let b: Double = log(1 / Double(fullPointVal)) / 5
        let timeScore: Int = Int(Double(fullPointVal) * pow(Darwin.M_E, b * timeElapsed))
        return timeScore
    }
}

struct Training_Previews: PreviewProvider {
    static var previews: some View {
        Training(points: 0, countdown: Binding.constant(false)).environmentObject(GlobalUser())
    }
}
