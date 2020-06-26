  
//
//  Training.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI

/** Training game. */
struct Training: View {

    /** Show summary view. */
    @State var summary = false
    
    /** Stars. */
    @State var points: Int

    /** List of answers. */
    @State var answers: [Answer] = []
    
    @Binding var countdown: Bool
    
    var body: some View {
        Group {
            if self.summary {
                Summary(answers: answers, countdown: $countdown)
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
    
    @State var q: Float = 0.2
    
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

    /** To close the view. */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    /** Keeps track of how much time has elapsed since beginning of question. */
    @State var timeElapsed: Double = 0.0
    
    /** Timer that pings the app every tenth of a second. */
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    /** How much is considered to be full score. */
    let fullPointVal: Int = 50
    
    var btnBack : some View {
        Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
            Image("close")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
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
                }
            }
            .padding(.top, 30.0)
            .padding(.horizontal, 30.0)
            .frame(height: 50.0)
            Spacer()
            Text("\(String(format: "%.1f", timeElapsed))")
                .font(.headingFont)
                .onReceive(timer) { _ in
                    if !self.stopped {
                        if !self.feedback {
                            self.timeElapsed += 0.1
                        }
                    }
                }

            Spacer()
            Group {
                if self.feedback {
                    if self.correct {
                        if self.user.regular == "promotion" {
                            PlusOne(playing: $feedback)
                        } else if self.user.regular == "prevention" {
                            MinusZero(playing: $feedback)
                        } else {
                            CheckMark(playing: $feedback)
                        }
                    } else {
                        if self.user.regular == "promotion" {
                            PlusZero(playing: $feedback)
                        } else if self.user.regular == "prevention" {
                            MinusOne(playing: $feedback)
                        } else {
                            XMark(playing: $feedback)
                        }
                    }
                } else {
                    Image(uiImage: UIImage(imageLiteralResourceName: models[self.folder][self.index].imageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 30.0)
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
            Alert(title: Text("Congratulations!"), message: Text("You have made it to the end of the training. Your final score is \(points)."), dismissButton: .default(Text("Session Summary"), action: {
                self.alert = false
                self.summary = true
            }))
        }
        .onAppear() {
            self.index = Int.random(in: 0..<self.models[self.folder].count)
        }
    }
    
    /** Action performed when friendly button clicked. */
    func friendlyButtonAction() -> () {
        if !self.stopped && !self.feedback {
            if self.folder == 0 {
                if self.user.regular == "promotion" || self.user.regular == "neutral"{
                    self.points += fullPointVal
                    self.points += calculateTimeScore()
                }
                self.correct = true
                self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "friendly", image: self.models[self.folder][self.index].imageURL, vehicleName: self.models[self.folder][self.index].vehicleName))
            } else {
                if self.user.regular == "prevention" {
                    // Wait lol unsure what to do here
                    self.points -= 2 * fullPointVal
                }
                self.correct = false
                self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "friendly", image: self.models[self.folder][self.index].imageURL, vehicleName: self.models[self.folder][self.index].vehicleName))
            }
            self.folder = Int.random(in: 0...1)
            self.index = Int.random(in: 0..<self.models[self.folder].count)
            self.feedback = true
            if self.questionCount == 19 {
                self.stopped = true
                self.alert = true
            }
            self.timeElapsed = 0.0
            self.questionCount += 1
        }
    }
    
    /** Action performed when enemy button clicked. */
    func enemyActionButton() -> () {
        if !self.stopped && !self.feedback {
            if self.folder == 1 {
                if self.user.regular == "promotion" || self.user.regular == "neutral" {
                    self.points += fullPointVal
                    self.points += calculateTimeScore()
                }
                self.correct = true
                self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "foe", image: self.models[self.folder][self.index].imageURL, vehicleName: self.models[self.folder][self.index].vehicleName))
            } else {
                if self.user.regular == "prevention" {
                    // Wait lol unsure what to do here
                    self.points -= 2 * fullPointVal
                }
                self.correct = false
                self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "foe", image: self.models[self.folder][self.index].imageURL, vehicleName: self.models[self.folder][self.index].vehicleName))
            }
            self.folder = Int.random(in: 0...1)
            self.index = Int.random(in: 0..<self.models[self.folder].count)
            self.feedback = true
            if self.questionCount == 19 {
                self.stopped = true
                self.alert = true
            }
            self.timeElapsed = 0.0
            self.questionCount += 1
        }
    }
    
    /** Calculates the score, out of 50 based on response time. */
    func calculateTimeScore() -> Int {
        let b: Double = 1 / Double(fullPointVal)
        let timeScore: Int = Int(Double(fullPointVal) * pow(pow(b, -1/5), -self.timeElapsed))
        return timeScore
    }
}

struct Training_Previews: PreviewProvider {
    static var previews: some View {
        Training(points: 0, countdown: Binding.constant(false)).environmentObject(GlobalUser())
    }
}
