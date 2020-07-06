//
//  GonogoTutorial.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 6/24/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

/** Gonogo game. */
struct GonogoTutorial: View {
    
    /** Show summary view. */
    @State var summary = false
    
    /** Points. */
    @State var points: Int
    
    /** Type. */
    @State var type:String
    
    /** List of answers. */
    @State var answers: [Answer] = []
    
    @Binding var countdown: Bool
    
    /** Whether we should show the about view. */
    @State var showAboutView: Bool
    
    /** Which about descriptor is active*/
    @State var activeAboutType: AboutType = .welcomeAbout
    
    /** Current description. */
    @State var aboutDescription: String = "Here you'll work on recognizing whether vehicles are friendly or enemy."
    
    /** Current tite. */
    @State var aboutTitle: String = "Welcome to Go/NoGo!"
    
    /** Whether the tutorial basics have already been completed. */
    @State var tutorialFirstRound: Bool = true
    
    /** Records the start of the session */
    var startTimestamp = Timestamp()
    
    var body: some View {
        Group {
            if self.summary {
                Summary(answers: answers, countdown: $countdown, session: Session(points: self.points, timestamp: self.startTimestamp, type: "Go/No-Go Tutorial"))
            } else {
                ZStack {
                    if showAboutView {
                       AboutViewGoNoGo(aboutTitle: $aboutTitle, aboutDescription: $aboutDescription, showAboutView: $showAboutView, activeAboutType: $activeAboutType, tutorialFirstRound: $tutorialFirstRound)
                           .zIndex(1)
                    }
                    
                    GonogoTutorialMain(summary: $summary, answers: $answers, points: $points, type: $type, aboutTitle: $aboutTitle, aboutDescription: $aboutDescription, activeAboutType: $activeAboutType, showAboutView: $showAboutView)
                    .onDisappear{
                        if !self.summary {
                            self.countdown = true
                        }
                    }
                }
            }
        }
    }
}

/** Main gonogo game view. */
struct GonogoTutorialMain: View {
    
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
    
     /** Points. */
    @Binding var type: String

    /** List of pictures grouped by friendly or foe. */
    let models = [Model.friendly, Model.foe]
    
    /** Friendly or foe folder selector.  0=friendly, 1=foe*/
    @State var folder = Int.random(in: 0...1)
    
    /** Timer that pings the app every second. */
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    /** To close the view. */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var aboutTitle: String
    @Binding var aboutDescription: String
    @Binding var activeAboutType: AboutType
    @Binding var showAboutView: Bool
    
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
                            Promotion(secondsElapsed: 20, points: 10, type:"correct", four: false, playing: $feedback)
                        } else if self.user.regular == "prevention" {
                            Prevention(secondsElapsed: 20, points: 10, type:"correct", four: false, playing: $feedback)
                        } else {
                            Neutral(secondsElapsed: 20, points: 10, type: "correct", four: false, playing: $feedback)
                        }
                    } else {
                        if self.user.regular == "promotion" {
                            Promotion(secondsElapsed: 20, points: 10, type: "incorrect", four: false, playing: $feedback)
                        } else if self.user.regular == "prevention" {
                            Prevention(secondsElapsed: 20, points: 10, type: "incorrect", four: false, playing: $feedback)
                        } else {
                            Neutral(secondsElapsed: 20, points: 10, type: "incorrect", four: false, playing: $feedback)
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
                self.enemyActionButton()
            }) {
                Text("ENEMY")
            }
            .buttonStyle(EnemyButtonStyle())
            
            Spacer()
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
        }
    }
    }
    
    /** Action performed when enemy button clicked. */
    func enemyActionButton() -> () {
        if !self.stopped && !self.feedback {
            if self.folder == 1 {
                if self.user.regular == "promotion" {
                    self.points += 50
                    changeAboutView(curAboutType: .correctPromotion)
                } else if self.user.regular == "neutral" {
                    self.points += 50
                    changeAboutView(curAboutType: .correctNeutral)
                } else if self.user.regular == "prevention" {
                    changeAboutView(curAboutType: .correctPrevention)
                }
                
                self.correct = true
                self.answers.append(Answer(id: self.answers.count, expected: "foe", received: "foe", image: self.models[self.folder][self.index].imageURL, vehicleName: self.models[self.folder][self.index].vehicleName))
            } else {
                if self.user.regular == "prevention" {
                    self.points -= 50
                    changeAboutView(curAboutType: .incorrectPrevention)
                } else if self.user.regular == "promotion" {
                    changeAboutView(curAboutType: .incorrectPromotion)
                } else if self.user.regular == "neutral" {
                    changeAboutView(curAboutType: .incorrectNeutral)
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
    
    func setCorrectDescriptor() -> () {
        switch activeAboutType {
            case .welcomeAbout:
                aboutTitle = "Welcome to training!"
                aboutDescription = "Here you'll work on recognizing whether vehicles are friendly or enemy."
            case .buttonAbout:
                aboutTitle = "Make a decision."
                aboutDescription = "If the vehicle is an enemy, hit the enemy button. Otherwise, do nothing. You have three seconds per trial."
            case .correctPromotion:
                aboutTitle = "You earned a star."
                aboutDescription = "Every question answered correctly grants you one star."
            case .correctPrevention:
                aboutTitle = "Correct."
                aboutDescription = "You did not lose a star. Answering questions incorrectly causes you to lose stars."
            case .correctNeutral:
                aboutTitle = "Correct."
                aboutDescription = ""
            case .progressBarAbout:
                aboutTitle = "Here's the progress bar."
                aboutDescription = "There are 20 questions per round."
            case .incorrectPrevention:
                aboutTitle = "You lost a star."
                aboutDescription = "Every question answered incorrectly causes you to lose one star."
            case .incorrectPromotion:
                aboutTitle = "Incorrect."
                aboutDescription = "You did not gain a star."
            case .incorrectNeutral:
                aboutTitle = "Incorrect."
                aboutDescription = "Try again next time."
            default:
                aboutDescription = ""
                aboutTitle = ""
        }
    }
    
    func changeAboutView(curAboutType: AboutType) -> () {
        self.activeAboutType = curAboutType
        self.setCorrectDescriptor()
        self.showAboutView = true
    }
    
     /** Questions remaining and time remaining. */
    func headline() -> some View {
        return VStack {
            HStack {
                btnBack
                if showAboutView == true && self.activeAboutType == .progressBarAbout {
                    ZStack {
                        ProgressBar(value: $questionCount)
                        Text("\(questionCount) / 20")
                            .font(.headline)
                            .foregroundColor(Color.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.red, lineWidth: 3)
                    )
                } else {
                    ZStack {
                        ProgressBar(value: $questionCount)
                            .padding(.horizontal)
                            .padding(.vertical, 10.0)
                        Text("\(questionCount) / 20")
                            .font(.headline)
                            .foregroundColor(Color.white)
                    }
                }
                
                if self.user.regular != "neutral" {
                    if showAboutView == true && [.correctPrevention, .correctPromotion, .correctNeutral, .incorrectPrevention, .incorrectPromotion, .incorrectNeutral].contains(self.activeAboutType) {
                        HStack {
                            Text("\(self.points)")
                                .font(.title)
                                .fontWeight(.bold)
                            Image("coin").resizable().frame(width: 40, height: 40)
                                .aspectRatio(contentMode: .fit)
                                .offset(y: -2)
                        }
                        .padding(.all, 5.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.red, lineWidth: 3)
                        )
                    } else {
                        Text("\(self.points)")
                            .font(.title)
                            .fontWeight(.bold)
                        Image("coin").resizable().frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fit)
                            .offset(y: -2)
                    }
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
                    if self.timeRemaining > 0 && !self.stopped && !self.showAboutView {
                        if !self.feedback {
                            self.timeRemaining -= 1
                        }
                    } else if !self.stopped && !self.showAboutView {
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

struct AboutViewGoNoGo: View {
    
    @Binding var aboutTitle: String
    @Binding var aboutDescription: String
    @Binding var showAboutView: Bool
    @Binding var activeAboutType: AboutType
    @Binding var tutorialFirstRound: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text(self.aboutTitle)
                    .font(Font.headingFont)
                    .padding(.bottom)
                Text(self.aboutDescription)
                    .font(Font.bodyFont)
                Button(action: {
                    if self.activeAboutType == .welcomeAbout {
                        self.showButtonAction()
                    } else if self.activeAboutType == .progressBarAbout {
                        self.tutorialFirstRound = false
                        self.showAboutView.toggle()
                    } else if [.correctPrevention, .correctPromotion, .correctNeutral, .incorrectPrevention, .incorrectPromotion, .incorrectNeutral].contains(self.activeAboutType) && self.tutorialFirstRound == true {
                        self.showProgressButtonAbout()
                    } else {
                        self.showAboutView.toggle()
                    }
                }) {
                    Text("KEEP GOING")
                }
                .padding(.top)
                .buttonStyle(CustomDefaultButtonStyle())
                .frame(height: 65)
            }
            .padding(.horizontal, 50)
            .frame(width: geo.size.width, height: geo.size.height * 0.35)
            .background(Color.white)
            .position(x: geo.size.width * 0.5, y: geo.size.height * 0.825)
        }
        .background(Color.black.opacity(0.5))
        .edgesIgnoringSafeArea(.top)
    }
    
    func showButtonAction() -> () {
        aboutTitle = "Make a decision."
        aboutDescription = "If the vehicle is an enemy, hit the enemy button. Otherwise, do nothing. You have three seconds per trial."
        self.activeAboutType = .buttonAbout
    }
    
    func showProgressButtonAbout() -> () {
        aboutTitle = "Here's the progress bar."
        aboutDescription = "There are 20 questions per round."
        self.activeAboutType = .progressBarAbout
    }
}

struct GonogoTutorial_Previews: PreviewProvider {
    static var previews: some View {
        GonogoTutorial(points: 0, type: "Gonogo", countdown: Binding.constant(false), showAboutView: true).environmentObject(GlobalUser())
    }
}

