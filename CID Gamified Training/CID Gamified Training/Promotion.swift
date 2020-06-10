//
//  Promotion.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/10/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Promotion: View {
    
    var body: some View {
        ZStack {
            VStack {
                Text("Nice job! Keep it up!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .position(x: 200, y: 260)
                LottieView(filename: "check")
                    .frame(width: 800, height: 800)
                    .position(x: 200, y: 0)
            }
        }
    }
}

struct Promotion_Previews: PreviewProvider {
    static var previews: some View {
        Promotion()
    }
}
