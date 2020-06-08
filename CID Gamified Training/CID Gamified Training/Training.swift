//
//  Training.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Training: View {
    
    @State var index = 1
    @State var points = 0
    
    var body: some View {
        VStack {
            Spacer()
            Text("Training")
                .font(.largeTitle)
                .fontWeight(.black)
            Spacer()
               
            Image("tank\(index)").resizable().scaledToFit()
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    if self.index == 1 {
                        self.points += 1
                    }
                    self.index = Int.random(in: 1...2)
                }) {
                    Text("Friendly")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                Spacer()
                Button(action: {
                    if self.index == 2 {
                        self.points += 1
                    }
                    self.index = Int.random(in: 1...2)
                }) {
                    Text("Foe")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                Spacer()
            }
            
            Spacer()
            Text("Points: \(points)")
                .font(.largeTitle)
                .fontWeight(.black)
            Spacer()
        }
    }
}

struct Training_Previews: PreviewProvider {
    static var previews: some View {
        Training()
    }
}
