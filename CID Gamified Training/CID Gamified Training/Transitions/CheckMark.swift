  
//
//  PlusOne.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI

struct CheckMark: View {
    @State var secondsElapsed:Double
    @State var points:Int
    @Binding var playing: Bool
    
    var body: some View {
        LottieView(fileName: "blue", playing: $playing)
            .frame(width: 300, height: 300)
            .background(Color.clear)
            .overlay(Text("\( String(format: "%.1f", secondsElapsed)) seconds").font(.largeTitle).fontWeight(.bold).offset(y:-150))
    }
}

struct CheckMark_Previews: PreviewProvider {
    static var previews: some View {
        CheckMark(secondsElapsed: 10, points:10, playing: Binding.constant(true))
    }
}
