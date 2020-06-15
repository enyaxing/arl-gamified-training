//
//  Training.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI
import Lottie

struct Training: View {
    
    /** Show summary view. */
    @State var summary = false
    
    /** List of answers. */
    @State var answers: [Answer] = []
    
    /** Back bar. */
    @Binding var back: Bool
    
    var body: some View {
        Group {
            if self.summary {
                Summary(answers: answers, back: $back)
            } else {
                TrainingMain(summary: $summary, answers: $answers)
            }
            } .navigationBarBackButtonHidden(back)
    }
}

struct TrainingMain: View {
    
    /** Index to keep track of which picture is shown. 1==friendly 2 == foe*/
    @State var index = Int.random(in: 1...2)
    
    /** Points gained from session. */
    @State var points = 0
    
    /** Session time remaining. */
    @State var sessionTime = 60
    
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
    
    /** Timer that pings the app every second. */
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Session Time: \(sessionTime)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .onReceive(timer) { _ in
                    if self.sessionTime > 0 && !self.stopped {
                            self.sessionTime -= 1
                        } else if !self.stopped {
                            self.stopped = true
                            self.alert = true
                    }
            }
            Spacer()
            Text("Training")
                .font(.largeTitle)
                .fontWeight(.black)
            Spacer()
            
            Group {
                if self.feedback {
                    if self.correct {
                        One(playing: $feedback)
                    } else {
                        Zero(playing: $feedback)
                    }
                } else {
                    Image("tank\(index)").resizable().scaledToFit()
                    Spacer()
                }
            }
            HStack {
                Spacer()
                Button(action: {
                    if !self.stopped && !self.feedback {
                        if self.index == 1 {
                            self.points += 1
                            self.correct = true
                            self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "friendly", image: "tank1"))
                        } else {
                            self.correct = false
                            self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "friendly", image: "tank2"))
                        }
                        self.index = Int.random(in: 1...2)
                        self.feedback = true
                    }
                }) {
                    Text("Friendly")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                Spacer()
                Button(action: {
                    if !self.stopped && !self.feedback {
                        if self.index == 2 {
                            self.points += 1
                            self.correct = true
                            self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "foe", image: "tank2"))
                        } else {
                            self.correct = false
                            self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "foe", image: "tank1"))
                        }
                        self.index = Int.random(in: 1...2)
                        self.feedback = true
                    }
                }) {
                    Text("Foe")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                Spacer()
            }
            Spacer()
            Text("Points: \(points)")
                .font(.largeTitle)
                .fontWeight(.black)
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Congratulations!"), message: Text("You have made it to the end of the training. Your final score is \(points)."), dismissButton: .default(Text("Quit"), action: {
                self.alert = false
                self.summary = true
            })
            )
            }
    }
}

struct Training_Previews: PreviewProvider {
    static var previews: some View {
        Training(back: ContentView().$back)
    }
}
