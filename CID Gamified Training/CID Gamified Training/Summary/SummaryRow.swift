//
//  SummaryRow.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/12/20.
//  Copyright © 2020 X-Force. All rights reserved.
//
import SwiftUI

/** The individual rows in the summary view. */
struct SummaryRow: View {
    
    /** One individual answer to be displayed. */
    var answer: Answer
    
    var body: some View {
        RoundedRectangle(cornerRadius: 40)
            .fill(color(answer: answer)).frame(width: 350, height: 50).overlay(
        HStack {
            Image(uiImage: UIImage(imageLiteralResourceName: answer.image))
            .resizable()
            .aspectRatio(contentMode: .fit)
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
            }.offset(x: 15)
        )
    }
}

/** Is the answer correct.
 Parameter:
    answer - The answer to be checked
 Return:
    Bool representing whether the answer is correct or not. */
func correct(answer: Answer) -> Bool {
    if answer.expected == answer.received {
        return true
    }
    return false
}

/** Background blue if correct and red if incorrect.
 Parameter:
    answer - The answer to be checked
 Return:
    Color to be displayed as background. */
func color(answer: Answer) -> Color {
    if correct(answer: answer) {
        return Color.darkBlue
    } else {
        return Color.enemyRed
    }
}

struct SummaryRow_Previews: PreviewProvider {
    static var previews: some View {
        SummaryRow(answer: Answer(id: 1, expected: "foe", received: "foe", image: "tank1", vehicleName: "tank1"))
    }
}
