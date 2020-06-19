//
//  Gonogo.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI

/** Gonogo game. */
struct Gonogo: View {
    
    /** Show summary view. */
    @State var summary = false
    
    /** Stars. */
    @State var stars: Int
    
    /** List of answers. */
    @State var answers: [Answer] = []
    
    /** Back bar. */
    @Binding var back: Bool
    
    var body: some View {
        Group {
            if self.summary {
                Summary(answers: answers, back: $back)
            } else {
                GonogoMain(summary: $summary, answers: $answers, stars: $stars)
            }
        }.navigationBarBackButtonHidden(back)
    }
}

/** Main gonogo game view. */
struct GonogoMain: View {
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: User
    
    /** Index to keep track of which picture is shown. 1==friendly 2 == foe*/
    @State var index = 0
    
    /** Time remaining for the turn. */
    @State var timeRemaining = 3
    
    /** Session time remaining. */
    @State var sessionTime = 20
    
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
    
    /** Stars. */
    @Binding var stars: Int
    
    /** List of pictures grouped by friendly or foe. */
    let models = [Model.friendly, Model.foe]
    
    /** Friendly or foe folder selector.  0=friendly, 1=foe*/
    @State var folder = Int.random(in: 0...1)
    
    /** Timer that pings the app every second. */
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            self.headline()
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
                }
            }.frame(width: 400, height: 400)
            Spacer()
            Button(action: {
                self.enemyButtonAction()
            }) {
                Text("Enemy")
                .font(.largeTitle)
                .fontWeight(.black)
            }
            Spacer()
            if self.user.regular != "neutral" {
                HStack {
                    Text("Stars Collected    ")
                    .fontWeight(.black)
                    .font(.largeTitle)
                    Text("\(self.stars)")
                    .fontWeight(.black)
                    .font(.largeTitle)
                    Image("star").resizable().frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fit)
                    .offset(y: -2)
                 }
            }
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Congratulations!"), message: Text("You have made it to the end of the training. Your final score is \(stars)."), dismissButton: .default(Text("Session Summary"), action: {
                self.alert = false
                self.summary = true
            })
            )
        }
    }
    
    /** Action performed when enemy button clicked. */
    func enemyButtonAction() -> () {
        if !self.stopped && !self.feedback {
            if self.folder == 1 {
                if self.user.regular == "promotion" {
                    self.stars += 1
                }
                self.correct = true
                self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "foe", image: self.models[self.folder][self.index].imageURL))
            } else {
                if self.user.regular == "prevention" {
                    self.stars -= 1
                }
                self.correct = false
                self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "foe", image: self.models[self.folder][self.index].imageURL))
            }
            self.folder = Int.random(in: 0...1)
            self.index = Int.random(in: 0..<self.models[self.folder].count)
            self.feedback = true
            self.timeRemaining = 3
            if self.sessionTime == 1 {
                self.stopped = true
                self.alert = true
            }
            self.sessionTime -= 1
        }
    }
    
     /** Questions remaining and time remaining. */
    func headline() -> some View {
        return VStack {
            Text("Questions Remaining: \(sessionTime)")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Time Remaining: \(timeRemaining)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .onReceive(timer) { _ in
                    if self.timeRemaining > 0 && !self.stopped {
                        if !self.feedback {
                            self.timeRemaining -= 1
                        }
                        } else if !self.stopped{
                            self.timeRemaining = 3
                            if self.folder == 0 {
                                if self.user.regular == "promotion" {
                                    self.stars += 1
                                }
                                self.correct = true
                                self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "friendly", image: self.models[self.folder][self.index].imageURL))
                            } else {
                                if self.user.regular == "prevention" {
                                    self.stars -= 1
                                }
                                self.correct = false
                                self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "friendly", image: self.models[self.folder][self.index].imageURL))
                        }
                        self.folder = Int.random(in: 0...1)
                        self.index = Int.random(in: 0..<self.models[self.folder].count)
                        self.feedback = true
                        if self.sessionTime == 1 {
                            self.stopped = true
                            self.alert = true
                        }
                        self.sessionTime -= 1
                    }
            }
        }
    }
    
    
}

struct Gonogo_Previews: PreviewProvider {
    static var previews: some View {
       Gonogo(stars: 0, back: Binding.constant(true)).environmentObject(User())
    }
}

