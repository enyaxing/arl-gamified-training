//
//  Promotion.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/10/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Life: View {
    @Binding var playing: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text("Nice job! Keep it up!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .position(x: 200, y: 100)
                LottieView(filename: "happy", playing: $playing)
                .frame(width: 50, height: 50)
                .position(x: 385, y: -120)
                LottieView(filename: "check", playing: $playing)
                    .frame(width: 800, height: 800)
                    .position(x: 200, y: 0)
            }
        }
    }
}

struct Life_Previews: PreviewProvider {
    static var previews: some View {
        Life(playing: Binding.constant(true))
    }
}
