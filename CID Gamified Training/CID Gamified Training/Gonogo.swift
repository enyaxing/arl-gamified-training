//
//  Gonogo.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Gonogo: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Go/NoGo")
                .font(.largeTitle)
                .fontWeight(.black)
            Spacer()
               
            Image("tank").resizable().scaledToFit()
            Spacer()
            
            Button(action: {}) {
                Text("Next")
                    .font(.largeTitle)
                    .fontWeight(.black)
            }
            Spacer()
        }
    }
}

struct Gonogo_Previews: PreviewProvider {
    static var previews: some View {
        Gonogo()
    }
}
