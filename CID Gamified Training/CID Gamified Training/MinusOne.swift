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
             LottieView(fileName: "minus", playing: $playing)
             .frame(width: 80, height: 80)
             .offset(x: 30)
             LottieView(fileName: "one", playing: $playing)
             .frame(width: 160, height: 160)
             .offset(x: 0)
             LottieView(fileName: "star", playing: $playing, isLoop: true)
             .frame(width: 180, height: 180)
             .offset(x: -20, y: -10)
            }
        }
    }
}

struct MinusOne_Previews: PreviewProvider {
    static var previews: some View {
        MinusOne(playing: Binding.constant(true))
    }
}
