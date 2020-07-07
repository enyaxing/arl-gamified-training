//
//  ContentView.swift
//  GridSwiftUI
//
//  Created by Mohammad Azam on 6/11/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//
import SwiftUI

struct Achievement: View {
    
    let achievements = ["🏆", "🏆", "🏆", "🏆", "🏆", "🏆"]
    @State private var sliderValue: CGFloat = 2.0
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                List(self.achievements.chunks(size: Int(self.sliderValue)), id: \.self) { chunk in
                    ForEach(chunk, id: \.self) { animal in
                        Text(animal)
                         .font(.system(size: CGFloat(300/self.sliderValue)))
                            .onTapGesture {
                                Text("hello")
                        }
                    }
                }
            }
            
            .navigationBarTitle("Achievements")
        }
    }
}

struct Achievement_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
