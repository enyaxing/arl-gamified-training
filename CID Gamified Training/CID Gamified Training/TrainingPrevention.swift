//
//  TrainingPrevention.swift
//  CID Gamified Training
//
//  Created by Alex on 6/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct TrainingPrevention: View {
    /** Index to keep track of which picture is shown. 1==friendly 2 == foe*/
    @State var index = 1
    
    /** Points gained from session. */
    @State var points = 0
    
    /** Session time remaining. */
    @State var sessionTime = 60
    
    /** Boolean to show if the training game has ended. */
    @State var stopped = false
    
    /** Boolean to show ending alert. */
    @State var alert = false

    /** Number of lives left. */
    @State var lives = 3
    
    /** Are you dead. */
    @State var dead = false
    
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
               
            Image("tank\(index)").resizable().scaledToFit()
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    if !self.stopped {
                        if self.index == 1 {
                            self.points += 1
                        } else {
                            self.lives -= 1
                            if self.lives == 0 {
                                self.dead = true
                                self.stopped = true
                            }
                        }
                        self.index = Int.random(in: 1...2)
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
                        } else {
                            self.lives -= 1
                            if self.lives == 0 {
                                self.dead = true
                                self.stopped = true
                            }
                        }
                        self.index = Int.random(in: 1...2)
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
                    if self.lives == 3 {
                        Image("heart").resizable().frame(width: 34, height: 34)
                        Image("heart").resizable().frame(width: 34, height: 34)
                        Image("heart").resizable().frame(width: 34, height: 34)
                    } else if self.lives == 2 {
                       Image("heart").resizable().frame(width: 34, height: 34)
                       Image("heart").resizable().frame(width: 34, height: 34)
                    } else if self.lives == 1 {
                       Image("heart").resizable().frame(width: 34, height: 34)
                    }
                }
            }
        }
        .alert(isPresented: $dead) {
            Alert(title: Text("You Lose!"), message: Text("You have no hearts remaining."), dismissButton: .default(Text("Quit"), action: {
                self.dead = false
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