//
//  PlusZero.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct WrongPromotion: View {
     @State var secondsElapsed:Double
    @Binding var playing: Bool
    var body: some View {
        VStack {
            Spacer()
            Text("\( String(format: "%.1f", secondsElapsed)) seconds")
                .font(.largeTitle)
                .fontWeight(.bold)

            LottieView(fileName: "stopwatch", playing: $playing)
            .frame(width: 300, height: 300)
            Text("+ 0 Points")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

struct WrongPromotion_Previews: PreviewProvider {
    static var previews: some View {
        WrongPromotion(secondsElapsed: 10, playing: Binding.constant(true))
    }
}
