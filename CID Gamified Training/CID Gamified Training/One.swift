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
        VStack {
            HStack {
                Text("Correct! Nice job!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                LottieView(filename: "happy", playing: $playing)
                .frame(width: 50, height: 50)
            }
            HStack {
                LottieView(filename: "blackplus", playing: $playing)
                .frame(width: 200, height: 300)
                LottieView(filename: "1", playing: $playing)
                .frame(width: 200, height: 300)
            }
        }
    }
}

struct One_Previews: PreviewProvider {
    static var previews: some View {
        One(playing: Binding.constant(true))
    }
}
