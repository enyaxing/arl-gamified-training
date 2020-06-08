//
//  End.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct End: View {
   var body: some View {
    VStack {
        Text("Congratulations!")
            .font(.largeTitle)
        Text("You've made it to the end!")
            .font(.largeTitle)
        Spacer()
        .frame(height: 50)
        Text("Total Points: " + String(Gonogo().points))
            .font(.largeTitle)
            .fontWeight(.bold)
    }
        }
    }

struct End_Previews: PreviewProvider {
    static var previews: some View {
        End()
    }
}
