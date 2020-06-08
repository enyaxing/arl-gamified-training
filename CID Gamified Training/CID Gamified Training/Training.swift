//
//  Training.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Training: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Training")
                .font(.largeTitle)
                .fontWeight(.black)
            Spacer()
               
            Image("tank1").resizable().scaledToFit()
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

struct Training_Previews: PreviewProvider {
    static var previews: some View {
        Training()
    }
}
