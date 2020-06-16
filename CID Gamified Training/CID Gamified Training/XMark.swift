//
//  PlusZero.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI

struct XMark: View {
    @Binding var playing: Bool
    var body: some View {
        VStack {
            HStack {
                Text("Wrong! Try Again")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                LottieView(fileName: "sad", playing: $playing)
                    .frame(width: 50, height: 50)
            }
            HStack {
             LottieView(fileName: "incorrect", playing: $playing)
             .frame(width: 400, height: 400)
                .background(Color.red)
            }
        }
    }
}

struct XMark_Previews: PreviewProvider {
    static var previews: some View {
        XMark(playing: Binding.constant(true))
    }
}
