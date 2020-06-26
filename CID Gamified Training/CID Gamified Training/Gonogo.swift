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
    
    /** Points. */
    @State var points: Int
    
    /** List of answers. */
    @State var answers: [Answer] = []
    
    @Binding var countdown: Bool
    
    var body: some View {
        Group {
            if self.summary {
                Summary(answers: answers, countdown: $countdown)
            } else {
                GonogoMain(summary: $summary, answers: $answers, points: $points)
                .onDisappear{
                    if !self.summary {
                        self.countdown = true
                    }
                }
            }
        }
    }
}

/** Main gonogo game view. */
struct GonogoMain: View {
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Index to keep track of which picture is shown. 1==friendly 2 == foe*/
    @State var index = 0
    
    /** Time remaining for the turn. */
    @State var timeRemaining = 3
    
    /** Session time remaining. */
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
    
    /** Timer that pings the app every second. */
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    /** Stopwatch. */
    @ObservedObject var stopWatchManager = StopWatchManager() 
    
    /** To close the view. */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
            self.headline()
            Spacer()
            Group {
                if self.feedback {
                    if self.correct {
                        if self.user.regular == "promotion" {
                            RightPromotion(secondsElapsed: stopWatchManager.secondsElapsed, points: 10, playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        } else if self.user.regular == "prevention" {
                            RightPrevention(secondsElapsed: stopWatchManager.secondsElapsed, points: 10, playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        } else {
                            CheckMark(secondsElapsed: stopWatchManager.secondsElapsed, points: 10, playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        }
                    } else {
                        if self.user.regular == "promotion" {
                            WrongPromotion(secondsElapsed: stopWatchManager.secondsElapsed, points:10,  playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        } else if self.user.regular == "prevention" {
                            WrongPrevention(secondsElapsed: stopWatchManager.secondsElapsed, points:10, playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        } else {
                            XMark(secondsElapsed: stopWatchManager.secondsElapsed, points: 10, playing: $feedback)
                            .onAppear {
                                self.stopWatchManager.stop()
                            }
                        }
                    }
                } else {
                    Image(uiImage: UIImage(imageLiteralResourceName: models[self.folder][self.index].imageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        self.stopWatchManager.start()
                    }
                }
            }.frame(width: 400, height: 400)
            Spacer()
            Button(action: {
                self.enemyActionButton()
            }) {
                Text("ENEMY")
            }
            .buttonStyle(EnemyButtonStyle())
            
            Spacer()
//            if self.user.regular != "neutral" {
//                HStack {
//                    Text("Stars Collected    ")
//                    .fontWeight(.black)
//                    .font(.largeTitle)
//                    Text("\(self.stars)")
//                    .fontWeight(.black)
//                    .font(.largeTitle)
//                    Image("star").resizable().frame(width: 40, height: 40)
//                    .aspectRatio(contentMode: .fit)
//                    .offset(y: -2)
//                 }
//            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .alert(isPresented: $alert) {
            Alert(title: Text("Congratulations!"), message: Text("You have made it to the end of the training. Your final score is \(points)."), dismissButton: .default(Text("Session Summary"), action: {
                self.alert = false
                self.summary = true
            })
            )
        }
        .onAppear() {
            self.index = Int.random(in: 0..<self.models[self.folder].count)
        }
    }
    
    /** Action performed when enemy button clicked. */
    func enemyActionButton() -> () {
        if !self.stopped && !self.feedback {
            if self.folder == 1 {
                if self.user.regular == "promotion" {
                    self.points += 50
                }
                self.correct = true
                self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "foe", image: self.models[self.folder][self.index].imageURL, vehicleName: self.models[self.folder][self.index].vehicleName))
            } else {
                if self.user.regular == "prevention" {
                    self.points -= 50
                }
                self.correct = false
                self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "foe", image: self.models[self.folder][self.index].imageURL, vehicleName: self.models[self.folder][self.index].vehicleName))
            }
            self.folder = Int.random(in: 0...1)
            self.index = Int.random(in: 0..<self.models[self.folder].count)
            self.feedback = true
            self.timeRemaining = 3
            if self.questionCount == 19 {
                self.stopped = true
                self.alert = true
            }
            self.questionCount += 1
        }
    }
    
     /** Questions remaining and time remaining. */
    func headline() -> some View {
        return VStack {
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
                    Image("coin").resizable().frame(width: 40, height: 40)
                        .aspectRatio(contentMode: .fit)
                        .offset(y: -2)
                }
            }
            .padding(.top, 30.0)
            .padding(.horizontal, 30.0)
            .frame(height: 50.0)
            
            Text("Time Remaining: \(timeRemaining)")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top)
                .onReceive(timer) { _ in
                    if self.timeRemaining > 0 && !self.stopped {
                        if !self.feedback {
                            self.timeRemaining -= 1
                        }
                        } else if !self.stopped{
                            self.timeRemaining = 3
                            if self.folder == 0 {
                                if self.user.regular == "promotion" {
                                    self.points += 50
                                }
                                self.correct = true
                                self.answers.append(Answer(id: self.answers.count, expected: "friendly", received: "friendly", image: self.models[self.folder][self.index].imageURL, vehicleName: self.models[self.folder][self.index].vehicleName))
                            } else {
                                if self.user.regular == "prevention" {
                                    self.points -= 50
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
                        self.questionCount += 1
                    }
            }
        }
    }
}

struct Gonogo_Previews: PreviewProvider {
    static var previews: some View {
       Gonogo(points: 0, countdown: Binding.constant(false)).environmentObject(GlobalUser())
    }
}

