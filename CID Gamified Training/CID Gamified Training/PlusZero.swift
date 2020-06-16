//
//  PlusZero.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct PlusZero: View {
      @Binding var playing: Bool
    var body: some View {
        VStack {
            HStack {
                Text("Wrong! Try Again")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .offset(y: 40)
                LottieView(fileName: "sad", playing: $playing)
                    .frame(width: 50, height: 50)
                    .offset(y: 40)
            }
            HStack {
             LottieView(fileName: "blackplus", playing: $playing)
             .frame(width: 200, height: 200)
             .offset(x: 140)
             LottieView(fileName: "0", playing: $playing)
             .frame(width: 160, height: 150)
             .offset(x: 60)
             LottieView(fileName: "star1", playing: $playing)
             .frame(width: 400, height: 400)
             .offset(x: -90)
            }
        }
    }
}

struct PlusZero_Previews: PreviewProvider {
    static var previews: some View {
        PlusZero(playing: Binding.constant(true))
    }
}
