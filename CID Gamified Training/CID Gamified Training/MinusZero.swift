//
//  MinusZero.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct MinusZero: View {
    @Binding var playing: Bool
    var body: some View {
        VStack {
            HStack {
                Text("Correct! Nice job!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .offset(y: 40)
                LottieView(filename: "happy", playing: $playing)
                .frame(width: 50, height: 50)
                .offset(y: 40)
            }
            HStack {
             LottieView(filename: "minus", playing: $playing)
             .frame(width: 80, height: 80)
             .offset(x: 140)
             LottieView(filename: "0", playing: $playing)
             .frame(width: 160, height: 150)
             .offset(x: 100)
             LottieView(filename: "star1", playing: $playing)
             .frame(width: 400, height: 400)
             .offset(x: -30)
            }
        }
    }
}

struct MinusZero_Previews: PreviewProvider {
    static var previews: some View {
        MinusZero(playing: Binding.constant(true))
    }
}
