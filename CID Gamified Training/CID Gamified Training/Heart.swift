//
//  Heart.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/10/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Heart: View {
    @Binding var playing: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Wrong!\nYou lost one life!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                LottieView(filename: "sad", playing: $playing)
                .frame(width: 50, height: 50)
            }
            LottieView(filename: "heart", playing: $playing)
                .frame(width: 400, height: 200)
        }
    }
}

struct Heart_Previews: PreviewProvider {
    static var previews: some View {
        Heart(playing: Binding.constant(true))
    }
}
