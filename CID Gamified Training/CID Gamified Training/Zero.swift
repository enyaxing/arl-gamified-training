//
//  Plus.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Zero: View {
    @Binding var playing: Bool
    var body: some View {
        ZStack {
            VStack {
                Text("Wrong! Try Again")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .position(x: 170, y: 230)
                LottieView(filename: "sad", playing: $playing)
                    .frame(width: 50, height: 50)
                    .position(x: 345, y: -60)
                HStack {
                    LottieView(filename: "blackplus", playing: $playing)
                    .frame(width: 400, height: 400)
                    .position(x: 125, y: -125)
                    LottieView(filename: "0", playing: $playing)
                    .frame(width: 300, height: 300)
                    .position(x: 110, y: -125)
                }
            }
        }
    }
}

struct Zero_Previews: PreviewProvider {
    static var previews: some View {
        Zero(playing: Binding.constant(true))
    }
}
