//
//  Rejection.swift
//  CID Gamified Training
//
//  Created by Alex on 6/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Rejection: View {
    var body: some View {
        Text("Please take the questionairre to determine your regulatory focus. You cannot play any training games until you are classified as either Prevention or Promotion.")
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
