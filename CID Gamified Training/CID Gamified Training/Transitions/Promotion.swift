//
//  Promotion.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 7/1/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Promotion: View {
    @State var secondsElapsed:Double
    @State var points:Int
    @State var type:String
    @State var multiply:Bool
    @Binding var playing: Bool
    var body: some View {
        Color.lightBlack.edgesIgnoringSafeArea(.all).overlay(
        Group {
            if (type == "correct") {
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
                            .foregroundColor(Color.white)
                        Spacer()
                        LottieView(fileName: "plus", playing: $playing)
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                        if (self.multiply) {
                            Text("200 Points")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        } else {
                            Text("\(self.points - 50) Points")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        }
                        Spacer()
                    }
                    .offset(x: 10, y: 80)
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Accuracy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                        LottieView(fileName: "plus", playing: $playing)
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                        if (self.multiply) {
                            Text("200 Points")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(width: 175, height: 60)
                            .foregroundColor(Color.white)
                        } else {
                            Text("50 Points")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        }
                        Spacer()
                }
              .offset(y: 100)
                Spacer()
                Image("line")
                .resizable()
                .foregroundColor(Color.clear)
                .frame(width: 400, height: 400)
                .offset(y: -50)
                Spacer()
                HStack {
                    Spacer()
                    Text("Total   ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    Spacer()
                        LottieView(fileName: "plus", playing: $playing)
                        .frame(width: 30, height: 30)
                      if (self.multiply) {
                        Text("400 Points")
                          .font(.largeTitle)
                          .fontWeight(.bold)
                          .foregroundColor(Color.white)
                      } else {
                        Text("\(self.points) Points")
                          .font(.largeTitle)
                          .fontWeight(.bold)
                          .foregroundColor(Color.white)
                      }
                    Spacer()
                }
                .offset(x: 20, y: -200)
                Spacer()
            }
        } else {
            VStack {
                Spacer()
                LottieView(fileName: "incorrect", playing: $playing)
                    .frame(width: 200, height: 200)
                    .offset(y: 60)
                VStack {
                    HStack {
                        Spacer()
                        Text("Time    ")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                        LottieView(fileName: "plus", playing: $playing)
                        .frame(width: 30, height: 30)
                        Text("0 Points")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                    }.offset(x: 20, y: 120)
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Accuracy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                        LottieView(fileName: "plus", playing: $playing)
                            .frame(width: 30, height: 30)
                            .offset(x: 3)
                        Text("0 Points")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                }.offset(y: 140)
                Spacer()
                Image("line")
                .resizable()
                .frame(width: 400, height: 350)
                .offset(y: -10)
                Spacer()
                HStack {
                    Spacer()
                    Text("Total   ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    Spacer()
                    LottieView(fileName: "plus", playing: $playing)
                        .frame(width: 30, height: 30)
                    Text("0 Points")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    Spacer()
                }.offset(x: 27, y: -160)
                Spacer()
                }.offset(y: -100)
                }
            }
        }
    )
    }
}

struct Promotion_Previews: PreviewProvider {
    static var previews: some View {
        Promotion(secondsElapsed: 10, points: 100, type: "incorrect", multiply: true, playing: Binding.constant(true))
    }
}
