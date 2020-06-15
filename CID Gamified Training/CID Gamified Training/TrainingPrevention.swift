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
    
    /** Back bar. */
    @Binding var back: Bool
    
    var body: some View {
        Group {
            if self.summary {
                Summary(answers: answers, back: $back)
            } else {
                TrainingPreventionMain(summary: $summary, answers: $answers)
            } 
        }.navigationBarBackButtonHidden(back)
    }
}

struct TrainingPreventionMain: View {
    /** Index to keep track of which picture is shown. 1==friendly 2 == foe*/
    @State var index = 0
    
    /** Points gained from session. */
    @State var points = 0
    
    /** Session time remaining. */
    @State var sessionTime = 60
    
    /** Boolean to show if the training game has ended. */
    @State var stopped = false

    /** Number of lives left. */
    @State var lives = 3
    
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
    
    /** List of pictures grouped by friendly or foe. */
    let models = [Model.friendly, Model.foe]
    
    /** Friendly or foe folder selector.  0=friendly, 1=foe*/
    @State var folder = Int.random(in: 0...1)
    
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
                        Life(playing: $feedback)
                    } else {
                        Heart(playing: $feedback)
                    }
                } else {
                    ImageView(withURL: models[self.folder][self.index].imageURL)
                }
            }.frame(width: 400, height: 400)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if !self.stopped {
                        if self.folder == 0 {
                            self.points += 1
                            self.correct = true
                            self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "friendly", image: self.models[self.folder][self.index].imageURL))
                        } else {
                            self.lives -= 1
                            self.correct = false
                            self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "friendly", image: self.models[self.folder][self.index].imageURL))
                            if self.lives == 0 {
                                self.dead = true
                                self.stopped = true
                            }
                        }
                        self.folder = Int.random(in: 0...1)
                        self.index = Int.random(in: 0..<self.models[self.folder].count)
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
                        if self.folder == 1 {
                            self.points += 1
                            self.correct = true
                            self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "foe", image: self.models[self.folder][self.index].imageURL))
                        } else {
                            self.lives -= 1
                            self.correct = false
                            self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "foe", image: self.models[self.folder][self.index].imageURL))
                            if self.lives == 0 {
                                self.dead = true
                                self.stopped = true
                            }
                        }
                        self.folder = Int.random(in: 0...1)
                        self.index = Int.random(in: 0..<self.models[self.folder].count)
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
                HStack {
                    Text("Lives Left")
                    
                    ForEach(0 ..< self.lives, id: \.self) { image in
                    Image("heart").resizable().frame(width: 34, height: 34)
                    }
                }
            }
        }
        .alert(isPresented: $dead) {
            Alert(title: Text("You Lose!"), message: Text("You have no hearts remaining."), dismissButton: .default(Text("Quit"), action: {
                self.dead = false
                self.summary = true
            })
            )
        }
    }
}

struct TrainingPrevention_Previews: PreviewProvider {
    static var previews: some View {
        TrainingPrevention(back: ContentView().$back)
    }
}
