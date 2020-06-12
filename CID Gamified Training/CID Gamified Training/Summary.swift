//
//  Summary.swift
//  CID Gamified Training
//
//  Created by Alex on 6/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Summary: View {

    var answers: [Answer]

    var body: some View {
        NavigationView {
            VStack {
                Text("Summary")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Text("Correct: \(countCorrect(answer: answers))")
                Text("Incorrect: \(incorrect(answer: answers))")
                Text("Percentage: \(percentage(answer: answers), specifier: "%.2f")%")
                List(self.answers, id: \.id) { answer in
                    NavigationLink(destination: SummaryDetail(answer: answer)) {
                        SummaryRow(answer: answer)
                    }
                }
            }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        }
    }
}

func countCorrect(answer: [Answer]) -> Int {
    var count = 0
    for ans in answer {
        if ans.expected == ans.received {
            count += 1
        }
    }

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary(answers: [Answer(id: 1, expected: "foe", received: "foe", image: "tank1"), Answer(id: 2, expected: "friend", received: "foe", image: "tank1")])
    }
}
