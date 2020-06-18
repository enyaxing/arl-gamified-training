//
//  Transition.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/17/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Countdown: View {
    /** Time remaining for the turn. */
    @State var timeRemaining = 3
    /** Back bar. */
    @Binding var back: Bool
    @Binding var playing: Bool
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        Text("\(timeRemaining)")
                .foregroundColor(Color.green)
                .font(.title)
                .fontWeight(.bold)
                   .onReceive(timer) { _ in
                       if self.timeRemaining > 0 {
                           self.timeRemaining -= 1
                       } else {
                         //        LottieView(fileName: "countdown", playing: $playing)
                         //        .frame(width: 700, height: 700)
                         //        .background(Color.clear)
                         //        .offset(y: -50)
                         //        .onDisappear(perform: {print("Root is disappearing")})
                    }
                }
//        
//        LottieView(fileName: "countdown", playing: $playing)
//        .frame(width: 700, height: 700)
//        .background(Color.clear)
//        .offset(y: -50)
//        .onDisappear(perform: {print("Root is disappearing")})
    }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        Countdown(back: Binding.constant(true),  playing: Binding.constant(true))
    }
}
