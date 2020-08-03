//
//  Rejection.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/11/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import SwiftUI

/** Rejection page shown when questionaiire has not been filled out. */
struct Rejection: View {
    var body: some View {
        Text("Please take the questionairre to determine your regulatory focus.        You cannot play any training games until you are classified as either Prevention, Promotion, or Neutral.")
        .font(.largeTitle)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct Rejection_Previews: PreviewProvider {
    static var previews: some View {
        Rejection()
    }
}
