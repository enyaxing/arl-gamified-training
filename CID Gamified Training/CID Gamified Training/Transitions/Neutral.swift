//
//  Neutral.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 7/1/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Neutral: View {
    // time taken to answer question
    @State var secondsElapsed:Double
    
    // is the reponse correct or incorrect?
    @State var type:String
    
    // is the animation playing?
    @Binding var playing: Bool
    var body: some View {
        Group {
        if (type == "correct") {
            LottieView(fileName: "blue", playing: $playing)
                .frame(width: 300, height: 300)
                .background(Color.clear)
                .overlay(Text("\( String(format: "%.1f", secondsElapsed)) seconds").font(.largeTitle).fontWeight(.bold).offset(y:-200).foregroundColor(Color.white))
        } else {
            LottieView(fileName: "incorrect", playing: $playing)
            .frame(width: 800, height: 800)
            .background(Color.clear)
            .overlay(Text("\( String(format: "%.1f", secondsElapsed)) seconds").font(.largeTitle).fontWeight(.bold).offset(y:-200).foregroundColor(Color.white))
            }
        }
    }
}

struct Neutral_Previews: PreviewProvider {
    static var previews: some View {
        Neutral(secondsElapsed: 10, type: "xmark", playing: Binding.constant(true))
    }
}
