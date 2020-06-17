//
//  Transition.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/17/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Transition: View {
    @Binding var playing: Bool
    var body: some View {
        LottieView(fileName: "countdown", playing: $playing)
        .frame(width: 700, height: 700)
    }
}

struct Transition_Previews: PreviewProvider {
    static var previews: some View {
        Transition(playing: Binding.constant(true))
    }
}
