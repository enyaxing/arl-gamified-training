//
//  SummaryRow.swift
//  CID Gamified Training
//
//  Created by Alex on 6/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct SummaryRow: View {
    
    var answer: Answer
    
    var body: some View {
        HStack {
            Image(answer.image).resizable()
                .frame(width: 50, height: 50)
            Group {
                if correct(answer: self.answer) {
                    Text("Correct!")
                        .font(.title)
                        .fontWeight(.semibold)
                } else {
                    Text("Incorrect!")
                    .font(.title)
                    .fontWeight(.semibold)
                }
            }
            Spacer()
            } .background(color(answer: answer))
    }
}

func correct(answer: Answer) -> Bool {
    if answer.expected == answer.received {
        return true
    }
    return false
}

func color(answer: Answer) -> Color {
    if correct(answer: answer) {
        return Color.green
    } else {
        return Color.red
    }
}

struct SummaryRow_Previews: PreviewProvider {
    static var previews: some View {
        SummaryRow(answer: Answer(id: 1, expected: "foe", received: "foe", image: "tank1"))
    }
}
