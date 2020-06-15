//
//  TrainingPrevention.swift
//  CID Gamified Training
//
//  Created by Alex on 6/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct TrainingPrevention: View {
    
    /** Show summary view. */
    @State var summary = false
    
    /** List of answers. */
    @State var answers: [Answer] = []
    
    var body: some View {
        Group {
            if self.summary {
                Summary(answers: answers)
            } else {
                TrainingPreventionMain(summary: $summary, answers: $answers)
            }
        }
    }
}

struct TrainingPreventionMain: View {
    /** Index to keep track of which picture is shown. 1==friendly 2 == foe*/
    @State var index = Int.random(in: 1...2)
    
    /** Points gained from session. */
    @State var points = 0
    
    /** Session time remaining. */
    @State var sessionTime = 60
    
    /** Boolean to show if the training game has ended. */
    @State var stopped = false

    /** Number of stars. */
    @State var stars = 20
    
    /** Are you dead. */
    @State var dead = false
    
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
                        MinusZero(playing: $feedback)
                    } else {
                        MinusOne(playing: $feedback)
                    }
                } else {
                    Image("tank\(index)").resizable().scaledToFit()
                    Spacer()
                }
            }
            
            HStack {
                Spacer()
                Button(action: {
                    if !self.stopped {
                        if self.index == 1 {
                            self.points += 1
                            self.correct = true
                            self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "friendly", image: "tank1"))
                        } else {
                            self.stars -= 1
                            self.correct = false
                            self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "friendly", image: "tank2"))
                            if self.stars == 0 {
                                self.dead = true
                                self.stopped = true
                            }
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
                    if !self.stopped {
                        if self.index == 2 {
                            self.points += 1
                            self.correct = true
                            self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "foe", image: "tank2"))
                        } else {
                            self.stars -= 1
                            self.correct = false
                            self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "foe", image: "tank1"))
                            if self.stars == 0 {
                                self.dead = true
                                self.stopped = true
                            }
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
           VStack {
                Text("Stars Remaining")
                .fontWeight(.black)
                HStack {
                    ForEach(0 ..< self.stars, id: \.self) { image in
                        Image("star").resizable().frame(width: 40, height: 40)
                    }
                }
            }
        }
        .alert(isPresented: $dead) {
            Alert(title: Text("You Lose!"), message: Text("You have no stars remaining."), dismissButton: .default(Text("Quit"), action: {
                self.dead = false
                self.summary = true
            })
            )
        }
    }
}

struct TrainingPrevention_Previews: PreviewProvider {
    static var previews: some View {
        TrainingPrevention()
    }
}
