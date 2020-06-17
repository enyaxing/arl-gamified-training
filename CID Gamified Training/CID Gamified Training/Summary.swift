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
    
    @Binding var back: Bool
    
    var regular: String

    var body: some View {
        VStack {
            Text("Summary")
                .font(.largeTitle)
                .fontWeight(.black)
            
            Group {
                if regular == "promotion" {
                    Text("Correct: \(countCorrect(answer: answers))/\(answers.count)")
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                } else if regular == "prevention" {
                    Text("Incorrect: \(incorrect(answer: answers))/\(answers.count)")
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                } else {
                    Text("Correct: \(countCorrect(answer: answers))")
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                    Text("Incorrect: \(incorrect(answer: answers))")
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                }
            }
            List(self.answers, id: \.id) { answer in
                NavigationLink(destination: SummaryDetail(answer: answer, back: self.$back)) {
                    SummaryRow(answer: answer)
                }
            }
        }
        .navigationBarTitle("")
    }
}

func countCorrect(answer: [Answer]) -> Int {
    var count = 0
    for ans in answer {
        if ans.expected == ans.received {
            count += 1
        }
    }
    return count
}

func incorrect(answer: [Answer]) -> Int {
    return answer.count - countCorrect(answer: answer)
}

func percentage(answer: [Answer]) -> Double {
    return ((Double(countCorrect(answer: answer)) / Double(answer.count)) * 100.0)
}

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary(answers: [Answer(id: 1, expected: "foe", received: "foe", image: "tank1"), Answer(id: 2, expected: "friend", received: "foe", image: "tank1")], back: Binding.constant(false), regular: "promotion")
    }
}
