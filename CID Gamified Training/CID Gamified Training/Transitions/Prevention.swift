//
//  Prevention.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 7/1/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Prevention: View {
    @State var secondsElapsed:Double
    @State var points:Int
    @State var type:String
    @State var multiply: Bool
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
                     .offset(y: 100)
                     VStack {
                         HStack {
                             Spacer()
                             Text("Time    ")
                                 .font(.largeTitle)
                                 .fontWeight(.bold)
                                .foregroundColor(Color.white)
                             Spacer()
                                 LottieView(fileName: "minus", playing: $playing)
                                 .frame(width: 20, height: 20)
                                 .offset(x: 10)
                            if self.multiply {
                                 Text("0 Points")
                                     .font(.largeTitle)
                                     .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                     .offset(x: 10)
                            } else {
                                Text("\(self.points) Points")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .offset(x: 10)
                            }
                                 Spacer()
                             }.offset(y: 80)
                             Spacer()
                             HStack {
                                 Spacer()
                                 Text("Accuracy")
                                     .font(.largeTitle)
                                     .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                 Spacer()
                                 LottieView(fileName: "minus", playing: $playing)
                                 .frame(width: 20, height: 20)
                                 Text("0 Points")
                                     .font(.largeTitle)
                                     .fontWeight(.bold)
                                    .foregroundColor(Color.white)
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
                                 .offset(y: -20)
                                .foregroundColor(Color.white)
                             Spacer()
                                 LottieView(fileName: "minus", playing: $playing)
                                 .frame(width: 20, height: 20)
                                 .offset(x: 0, y: -20)
                                if self.multiply {
                                     Text("0 Points")
                                         .font(.largeTitle)
                                         .fontWeight(.bold)
                                        .offset(x: 10, y: -20)
                                        .foregroundColor(Color.white)
                                } else {
                                    Text("\(self.points) Points")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .offset(x: 10, y: -20)
                                    .foregroundColor(Color.white)
                                }
                             Spacer()
                         }.offset(y: -200)
                         Spacer()
                         }.offset(y: 0)
                     }
               } else {
                VStack {
                    Spacer()
                    LottieView(fileName: "incorrect", playing: $playing)
                        .frame(width: 200, height: 200)
                        .background(Color.clear)
                        .offset(y:60)
                        VStack {
                            HStack {
                                Spacer()
                                Text("Time    ")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                Spacer()
                                    LottieView(fileName: "minus", playing: $playing)
                                    .frame(width: 20, height: 20)
                                    .offset(x: 10)
                                    if self.multiply {
                                         Text("200 Points")
                                             .font(.largeTitle)
                                             .fontWeight(.bold)
                                             .offset(x: 10)
                                            .foregroundColor(Color.white)
                                    } else {
                                        Text("50 Points")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .offset(x: 10)
                                        .foregroundColor(Color.white)
                                    }
                                    Spacer()
                                }.offset(y: 80)
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text("Accuracy")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    Spacer()
                                    LottieView(fileName: "minus", playing: $playing)
                                    .frame(width: 20, height: 20)
                                    if self.multiply {
                                         Text("200 Points")
                                             .font(.largeTitle)
                                             .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    } else {
                                        Text("50 Points")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    }
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
                                    .offset(y: -20)
                                    .foregroundColor(Color.white)
                                Spacer()
                                    LottieView(fileName: "minus", playing: $playing)
                                    .frame(width: 20, height: 20)
                                        .offset(x: 10, y: -20)
                                    if self.multiply {
                                         Text("400 Points")
                                             .font(.largeTitle)
                                             .fontWeight(.bold)
                                            .offset(x: 10, y: -20)
                                            .foregroundColor(Color.white)
                                    } else {
                                        Text("100 Points")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .offset(x: 10, y: -20)
                                        .foregroundColor(Color.white)
                                    }
                                Spacer()
                            }.offset(y: -200)
                            Spacer()
                            }.offset(y: -100)
                        }
                   }
               }
        )
    }
}

struct Prevention_Previews: PreviewProvider {
    static var previews: some View {
        Prevention(secondsElapsed: 10, points: 10, type: "incorrect", multiply: false, playing: Binding.constant(true))
    }
}
