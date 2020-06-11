//
//  Gonogo.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Gonogo: View {
    
    /** Index to keep track of which picture is shown. 1==friendly 2 == foe*/
    @State var index = Int.random(in: 1...2)
    
    /** Points gained from session. */
    @State var points = 0
    
    /** Time remaining for the turn. */
    @State var timeRemaining = 3
    
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
    
    /** Timer that pings the app every second. */
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
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
                
                Text("Time Remaining: \(timeRemaining)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .onReceive(timer) { _ in
                        if self.timeRemaining > 0 && !self.stopped {
                                self.timeRemaining -= 1
                            } else if !self.stopped{
                                self.timeRemaining = 3
                                if self.index == 1 {
                                    self.points += 1
                                }
                                self.index = Int.random(in: 1...2)
                        }
                }
            }
            
            Spacer()
            Text("Go/NoGo")
                .font(.largeTitle)
                .fontWeight(.black)
            Spacer()
               
            Group {
                if self.feedback {
                    if self.correct {
                        LottieView(filename: "correct", playing: $feedback).scaledToFit()
                    } else {
                        LottieView(filename: "incorrect", playing: $feedback).scaledToFit()
                    }
                } else {
                    Image("tank\(index)").resizable().scaledToFit()
                    Spacer()
                }
            }
            
            Button(action: {
                if !self.stopped {
                    if self.index == 2 {
                        self.points += 1
                    }
                    self.timeRemaining = 3
                    self.index = Int.random(in: 1...2)
                }
            }) {
                Text("Foe")
                    .font(.largeTitle)
                    .fontWeight(.black)
            }
            Spacer()
            Text("Points: \(points)")
                .font(.largeTitle)
                .fontWeight(.black)
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Congratulations!"), message: Text("You have made it to the end of the training. Your final score is \(points)"), dismissButton: .default(Text("Quit"), action: {
                self.alert = false
            })
            )
        }
    }
}

struct Gonogo_Previews: PreviewProvider {
    static var previews: some View {
        Gonogo()
    }
}
