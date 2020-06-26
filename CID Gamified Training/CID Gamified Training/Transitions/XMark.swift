//
//  PlusZero.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI

struct XMark: View {
    @State var secondsElapsed:Double
    @Binding var playing: Bool
    var body: some View {
        LottieView(fileName: "incorrect", playing: $playing)
            .frame(width: 900, height: 900)
            .background(Color.clear)
            .overlay(Text("\( String(format: "%.1f", secondsElapsed)) seconds").font(.largeTitle).fontWeight(.bold).offset(y:-150))
    }
}

struct XMark_Previews: PreviewProvider {
    static var previews: some View {
        XMark(secondsElapsed: 10, playing: Binding.constant(true))
    }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
