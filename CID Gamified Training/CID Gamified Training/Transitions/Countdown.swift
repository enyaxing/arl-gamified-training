//
//  Transition.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/17/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Countdown: View {
//    * Time remaining for the turn.
    @State var timeRemaining = 3
    @Binding var playing: Bool
    
   
    var body: some View {
        ZStack {
            LottieView(fileName: "countdown", playing: $playing)
                .frame(width: 700, height: 700)
                .edgesIgnoringSafeArea(.all)
                .background(Color.clear)
                .offset(y: 300)
        }
    }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        Countdown(playing: Binding.constant(true))
    }
}
