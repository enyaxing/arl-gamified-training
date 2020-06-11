//
//  Heart.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/10/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Heart: View {
    @State var playing = true
    
    var body: some View {
        ZStack {
            VStack {
                Text("Wrong!                                     You lost one life")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .position(x: 200, y: 220)
                LottieView(filename: "sad", playing: $playing)
                .frame(width: 50, height: 50)
                .position(x: 360, y: -50)
                LottieView(filename: "heart", playing: $playing)
                    .frame(width: 600, height: 600)
                    .position(x: 200, y: -135)
            }
        }
    }
}

struct Heart_Previews: PreviewProvider {
    static var previews: some View {
        Heart()
    }
}
