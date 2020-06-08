//
//  Gonogo.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Gonogo: View {
    
    @State var index = 1
    @State var points = 0
    
    var body: some View {
        VStack {
            Spacer()
            Text("Go/NoGo")
                .font(.largeTitle)
                .fontWeight(.black)
            Spacer()
               
            Image("tank\(index)").resizable().scaledToFit()
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
            Text("Points: \(points)")
                .font(.largeTitle)
                .fontWeight(.black)
            Spacer()
        }
    }
}

struct Gonogo_Previews: PreviewProvider {
    static var previews: some View {
        Gonogo()
    }
}
