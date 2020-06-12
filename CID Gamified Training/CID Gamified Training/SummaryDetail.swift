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
    
    var body: some View {
        VStack {
            Image(self.answer.image).resizable().scaledToFit()
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
    }
}

struct SummaryDetail_Previews: PreviewProvider {
    static var previews: some View {
        SummaryDetail(answer: Answer(id: 1, expected: "foe", received: "foe", image: "tank1"))
    }
}
