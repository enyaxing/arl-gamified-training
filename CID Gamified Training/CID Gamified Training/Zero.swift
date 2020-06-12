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
        VStack {
            
            HStack {
                Text("Wrong! Try Again")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                LottieView(filename: "sad", playing: $playing)
                    .frame(width: 50, height: 50)
            }
            HStack {
                LottieView(filename: "blackplus", playing: $playing)
                .frame(width: 200, height: 300)
                LottieView(filename: "0", playing: $playing)
                .frame(width: 200, height: 300)
            }
        }
    }
}

struct Zero_Previews: PreviewProvider {
    static var previews: some View {
        Zero(playing: Binding.constant(true))
    }
}
