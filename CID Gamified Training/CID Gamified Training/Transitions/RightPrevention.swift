//
//  MinusZero.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct RightPrevention: View {
    @State var secondsElapsed:Double
    @State var points:Int
    @Binding var playing: Bool
    var body: some View {
        VStack {
            Spacer()
            LottieView(fileName: "blue", playing: $playing)
                .frame(width: 100, height: 100)
                .background(Color.clear)
                .offset(y: 90)
                HStack {
                    Spacer()
                    Text("Time    ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    LottieView(fileName: "minus", playing: $playing)
                    .frame(width: 20, height: 20)
                    Text("\(self.points) Points")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.offset(y: 80)
                Spacer()
                HStack {
                    Spacer()
                    Text("Accuracy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    LottieView(fileName: "minus", playing: $playing)
                    .frame(width: 20, height: 20)
                    Text("0 Points")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
            }.offset(y: 100)
            Spacer()
            Image("line")
            .resizable()
            .frame(width: 400, height: 400)
            .offset(y: -50)
            Spacer()
            HStack {
                Spacer()
                Text("Total   ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                LottieView(fileName: "minus", playing: $playing)
                .frame(width: 20, height: 20)
                Text("\(self.points) Points")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -200)
            Spacer()
        }
    }

}

struct RightPrevention_Previews: PreviewProvider {
    static var previews: some View {
        RightPrevention(secondsElapsed: 10, points: 10, playing: Binding.constant(true))
    }
}
