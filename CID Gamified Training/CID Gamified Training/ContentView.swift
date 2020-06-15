//
//  ContentView.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let defaults = UserDefaults.standard
    
    @State var regular = focus(defaults: UserDefaults.standard)
    
    @State var back = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("ARL Gamified Training")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                Spacer()
                
                NavigationLink(destination: Question(curResponse: 0, regular: $regular)) {
                    Text("Questionairre")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                    
                }
                Spacer()
                
                NavigationLink(destination:
                    Group {
                        if self.regular == "promotion" {
                            Training(back: $back)
                        } else if self.regular == "prevention" {
                            TrainingPrevention(back: $back)
                        } else {
                            Rejection()
                        }
                    }) {
                    Text("Training")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                }
                Spacer()
                NavigationLink(destination:
                    Group {
                        if self.regular == "promotion" {
                            Gonogo(back: $back)
                        } else if self.regular == "prevention" {
                            GonogoPrevention(back: $back)
                        } else {
                            Rejection()
                        }
                    }) {
                    Text("Go/NoGo")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                }
                Spacer()
                Text(self.regular)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
            }
            .background(Image("background"))
        }
    }
}

func focus(defaults: UserDefaults) -> String {
    return defaults.string(forKey: "focus") ?? "None"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
