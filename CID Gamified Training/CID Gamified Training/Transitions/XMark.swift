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
        ZStack {
            LottieView(fileName: "incorrect", playing: $playing)
                .frame(width: 1000, height: 1000)
        }
    }
}

struct XMark_Previews: PreviewProvider {
    static var previews: some View {
        XMark(playing: Binding.constant(true))
    }
}
