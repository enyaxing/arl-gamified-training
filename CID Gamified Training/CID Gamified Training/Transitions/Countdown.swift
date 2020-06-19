//
//  Transition.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/17/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Countdown: View {
    @Binding var playing: Bool
    
   
    var body: some View {
        ZStack {
            LottieView(fileName: "countdown", playing: $playing)
                .frame(width: 800, height: 800)
                .background(Color.clear)
                .scaledToFit()
                .offset(y: 50)
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        Countdown(playing: Binding.constant(true))
    }
}
