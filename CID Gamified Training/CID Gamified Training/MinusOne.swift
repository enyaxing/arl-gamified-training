//
//  MinusOne.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct MinusOne: View {
    @Binding var playing: Bool
    var body: some View {
        VStack {
            HStack {
                Text("Wrong! You lost one star!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .offset(y: 40)
            }
            HStack {
             LottieView(fileName: "minus", playing: $playing)
             .frame(width: 80, height: 80)
             .offset(x: 140)
             LottieView(fileName: "1", playing: $playing)
             .frame(width: 150, height: 150)
             .offset(x: 120)
             LottieView(fileName: "star1", playing: $playing)
             .frame(width: 400, height: 400)
             .offset(x: -30)
            }
        }
    }
}

struct MinusOne_Previews: PreviewProvider {
    static var previews: some View {
        MinusOne(playing: Binding.constant(true))
    }
}
