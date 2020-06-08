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
    @State var timeRemaining = 5
    let images = [Image("tank1"), Image("tank2")]
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            Text("Time Remaining: \(timeRemaining)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .onReceive(timer) { _ in
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                        } else{
                            self.timeRemaining = 5
                            self.index = self.index + 1
                    }
            }
            
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
                self.timeRemaining = 5
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
