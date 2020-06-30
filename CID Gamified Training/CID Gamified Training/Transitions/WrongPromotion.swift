//
//  PlusZero.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct WrongPromotion: View {
    @State var secondsElapsed:Double
    @State var points:Int
    @Binding var playing: Bool
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Time    ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    LottieView(fileName: "plus", playing: $playing)
                    .frame(width: 60, height: 60)
                    Text("\(self.points) Points")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text("Accuracy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    LottieView(fileName: "plus", playing: $playing)
                        .frame(width: 60, height: 60)
                    Text("0 Points")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                Spacer()
            }.offset(y: 100)
            Spacer()
            Image("line")
            .resizable()
            .frame(width: 400, height: 400)
            .offset(y: -110)
            Spacer()
            HStack {
                Spacer()
                Text("Total   ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                LottieView(fileName: "plus", playing: $playing)
                    .frame(width: 60, height: 60)
                Text("\(self.points) Points")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }.offset(y: -300)
            Spacer()
        }
    }
}

struct WrongPromotion_Previews: PreviewProvider {
    static var previews: some View {
        WrongPromotion(secondsElapsed: 10, points: 10, playing: Binding.constant(true))
    }
}
