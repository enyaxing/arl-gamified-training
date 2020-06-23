//
//  Summary.swift
//  CID Gamified Training
//
//  Created by Alex on 6/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI

/** The summary view after session completed. */
struct Summary: View {
    
    /** List of answers from completed training session. */
    var answers: [Answer]
    
    @State var hideback = false
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    @Binding var countdown: Bool

    var body: some View {
        VStack {
            Text("Summary")
            .font(.largeTitle)
            .fontWeight(.black)
            Group {
                if self.user.regular == "promotion" {
                    Text("Correct: \(countCorrect(answer: answers))/\(answers.count)")
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                } else if self.user.regular == "prevention" {
                    Text("Incorrect: \(incorrect(answer: answers))/\(answers.count)")
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                } else {
                    Text("Correct: \(countCorrect(answer: answers))")
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    Text("Incorrect: \(incorrect(answer: answers))")
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                }
            }
            List(self.answers, id: \.id) { answer in
                NavigationLink(destination: SummaryDetail(answer: answer, back: self.$hideback)) {
                    SummaryRow(answer: answer)
                }
            }
        } .navigationBarBackButtonHidden(hideback)
        .onDisappear{
            if !self.hideback {
                self.countdown = true
            }
        }
    }
}

/** Count the number of correct answers. */
func countCorrect(answer: [Answer]) -> Int {
    var count = 0
    for ans in answer {
        if ans.expected == ans.received {
            count += 1
        }
    }
    return count
}

/** Count the number of incorrect answers. */
func incorrect(answer: [Answer]) -> Int {
    return answer.count - countCorrect(answer: answer)
}

/** Calculate percentage of correct answers. */
func percentage(answer: [Answer]) -> Double {
    return ((Double(countCorrect(answer: answer)) / Double(answer.count)) * 100.0)
}

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary(answers: [Answer(id: 1, expected: "foe", received: "foe", image: "tank1", vehicleName: "tank1")], countdown: Binding.constant(false)).environmentObject(GlobalUser())
    }
}
