  
//
//  PlusOne.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI

struct CheckMark: View {
    @Binding var playing: Bool
    var body: some View {
         VStack {
                HStack {
                    Text("Correct! Nice job!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    LottieView(fileName: "happy", playing: $playing)
                       .frame(width: 50, height: 50)
                   }
                   HStack {
                    LottieView(fileName: "correct", playing: $playing)
                    .frame(width: 400, height: 400)
                        .background(Color.green)
                   }
        }
    }
}

struct CheckMark_Previews: PreviewProvider {
    static var previews: some View {
        CheckMark(playing: Binding.constant(true))
    }
}
