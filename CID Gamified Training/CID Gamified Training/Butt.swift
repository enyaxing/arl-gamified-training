//
//  Butt.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/22/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Butt: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: Text("second view")) {
                Image("info")
                .resizable()
                .frame(width: 30, height: 30)
                .background(Color.clear)
            }
        }
    }
}

struct Butt_Previews: PreviewProvider {
    static var previews: some View {
        Butt()
    }
}
