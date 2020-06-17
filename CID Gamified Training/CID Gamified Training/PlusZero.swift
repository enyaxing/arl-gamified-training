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
             LottieView(fileName: "blackplus", playing: $playing)
             .frame(width: 200, height: 200)
             .offset(x: 30)
             LottieView(fileName: "zero", playing: $playing)
             .frame(width: 160, height: 160)
             .offset(x: -50)
             LottieView(fileName: "star", playing: $playing, isLoop: true)
             .frame(width: 180, height: 180)
             .offset(x: -80, y: -10)
            }
        }
    }
}

struct PlusZero_Previews: PreviewProvider {
    static var previews: some View {
        PlusZero(playing: Binding.constant(true))
    }
}
