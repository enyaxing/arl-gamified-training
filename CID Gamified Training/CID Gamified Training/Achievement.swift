//
//  ContentView.swift
//  GridSwiftUI
//
//  Created by Mohammad Azam on 6/11/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//
import SwiftUI

struct Achievement: View {
    
    var index = 0
    
    var promotion = [Text("Earn 100 Points"), Text("Earn 500 Points"), Text("Earn 1000 Points"), Text("Earn 2000 Points")]
    
    var prevention = [Text("Lose 0 Points"), Text("Lose 50 Points"), Text("Lose 100 Points"), Text("Lose 200 Points")]
    
    var neutral = [Text("Get 5 Questions Correct"), Text("Get 10 Questions Correct"), Text("Get 20 Questions Correct"), Text("Get 50 Questions Correct")]
    
    var body: some View {
        
    NavigationView {
        ScrollView(.vertical) {
            VStack(spacing: 10) {
                Text("Achievements")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Picker(selection: .constant(1), label: Text("Focus Style")) {
                    Text("Promotion").tag(1)
                    Text("Prevention").tag(2)
                    Text("Neutral").tag(3)
                }
                ForEach(promotion.indices) { index in
                    HStack {
                        VStack {
                            Image("medal").resizable().frame(width: 200, height: 200)
                            self.promotion[index]
                        }
                        VStack {
                            Image("medal").resizable().frame(width: 200, height: 200)
                            self.promotion[index]
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Achievement_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
