//
//  Stationary .swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Loop_: View {
    @Binding var playing: Bool
    var body: some View {
        LottieView(filename: "TwitterHeart", playing: $playing, isLoop: true)
        .frame(width: 1000, height: 1000)
    }
}

struct Loop__Previews: PreviewProvider {
    static var previews: some View {
        Loop_(playing: Binding.constant(true))
    }
}
