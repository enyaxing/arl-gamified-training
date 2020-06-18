  
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
            LottieView(fileName: "correct", playing: $playing)
            .frame(width: 900, height: 900)
            .background(Color.clear)
            }
        }
    }
}

struct CheckMark_Previews: PreviewProvider {
    static var previews: some View {
        CheckMark(playing: Binding.constant(true))
    }
}