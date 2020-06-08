//
//  ContentView.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("ARL Gamified Training")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Spacer()
                
                NavigationLink(destination: Question()) {
                    Text("Questionairre")
                    .font(.largeTitle)
                    .fontWeight(.black)
                }
                Spacer()
                
                NavigationLink(destination: Training()) {
                    Text("Training")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                Spacer()
                NavigationLink(destination: Training()) {
                    Text("Go/NoGo")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
