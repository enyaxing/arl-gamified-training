//
//  PlusOne.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct PlusOne: View {
    @Binding var playing: Bool
    var body: some View {
         VStack {
                HStack {
                    Text("Correct! Nice job!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    LottieView(fileName: "happy", playing: $playing)
                       .frame(width: 50, height: 50)
                   }
                   HStack {
                    LottieView(fileName: "blackplus", playing: $playing)
                    .frame(width: 200, height: 200)
                    .offset(x: 140)
                    LottieView(fileName: "1", playing: $playing)
                    .frame(width: 150, height: 150)
                    .offset(x: 60)
                    LottieView(fileName: "star1", playing: $playing)
                    .frame(width: 400, height: 400)
                    .offset(x: -90)
                   }
        }
    }
}

struct PlusOne_Previews: PreviewProvider {
    static var previews: some View {
        PlusOne(playing: Binding.constant(true))
    }
}
