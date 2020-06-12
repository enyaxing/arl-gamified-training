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
            VStack {
                HStack {
                    Text("Nice job! Keep it up!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    LottieView(filename: "happy", playing: $playing)
                    .frame(width: 50, height: 50)
                }
                LottieView(filename: "check", playing: $playing)
                    .frame(width: 400, height: 300)
            }
    }
}

struct Life_Previews: PreviewProvider {
    static var previews: some View {
        Life(playing: Binding.constant(true))
    }
}
