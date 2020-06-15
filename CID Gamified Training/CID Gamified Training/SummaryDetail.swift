//
//  SummaryDetail.swift
//  CID Gamified Training
//
//  Created by Alex on 6/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct SummaryDetail: View {
    
    var answer: Answer
    
    @Binding var back: Bool
    
    var body: some View {
        VStack {
            Image(self.answer.image).resizable().scaledToFit()
            if self.answer.expected == self.answer.received {
                HStack {
                    VStack {
                 Text("You chose ")
                     .font(.title)
                     .fontWeight(.semibold)
                + Text(self.answer.expected)
                     .font(.title)
                     .fontWeight(.semibold)
                     .foregroundColor(Color.green)
                + Text(",")
                    .font(.title)
                    .fontWeight(.semibold)
                 Text("the correct answer.")
                    .font(.title)
                    .fontWeight(.semibold)
                }
              }
            } else {
             HStack {
             Text("The correct answer is")
                 .font(.title)
                 .fontWeight(.semibold)
            Text(self.answer.expected)
                 .font(.title)
                 .fontWeight(.semibold)
                 .foregroundColor(Color.green)
             + Text(".")
                 .font(.title)
                 .fontWeight(.semibold)
                }
         HStack {
             Text("You chose")
                 .font(.title)
                 .fontWeight(.semibold)
            Text(self.answer.received)
                 .font(.title)
                 .fontWeight(.semibold)
                 .foregroundColor(Color.red)
             + Text(".")
                 .font(.title)
                 .fontWeight(.semibold)
                }
            }
        }.onAppear {
            self.back = true
        }.onDisappear {
            self.back = false
        }
    }
}

struct SummaryDetail_Previews: PreviewProvider {
    static var previews: some View {
        SummaryDetail(answer: Answer(id: 1, expected: "foe", received: "foe", image: "tank1"), back: ContentView().$back)
    }
}
