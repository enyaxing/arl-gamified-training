//
//  Heart.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/10/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Heart: View {
    var body: some View {
        ZStack {
            VStack {
                Text("You lost one life  ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .position(x: 200, y: 220)
                LottieView(filename: "sad")
                .frame(width: 50, height: 50)
                .position(x: 350, y: -70)
                LottieView(filename: "heart")
                    .frame(width: 600, height: 600)
                    .position(x: 200, y: -155)
            }
        }
    }
}

struct Heart_Previews: PreviewProvider {
    static var previews: some View {
        Heart()
    }
}
