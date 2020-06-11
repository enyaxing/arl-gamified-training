//
//  One.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct One: View {
    @Binding var playing: Bool
    var body: some View {
        ZStack {
            VStack {
                Text("Correct! Nice job!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .position(x: 200, y: 230)
                HStack {
                    LottieView(filename: "blackplus", playing: $playing)
                    .frame(width: 400, height: 400)
                    .position(x: 125, y: 0)
                    LottieView(filename: "1", playing: $playing)
                    .frame(width: 300, height: 300)
                    .position(x: 110, y: 0)
                }
            }
        }
    }
}

struct One_Previews: PreviewProvider {
    static var previews: some View {
        One(playing: Binding.constant(true))
    }
}
