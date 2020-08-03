//
//  SummaryDetail.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/12/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import SwiftUI

/** Detailed description of a single answer. */
struct SummaryDetail: View {
    
    /** A single answer to be displayed. */
    var answer: Answer
    
    /** Hide navigation back button. */
    @Binding var back: Bool
    
    var body: some View {
        Color.lightBlack.edgesIgnoringSafeArea(.all).overlay(
            VStack {
                Image(uiImage: UIImage(imageLiteralResourceName: self.answer.image))
                .resizable()
                .aspectRatio(contentMode: .fit)
                if self.answer.expected == self.answer.received {
                    HStack {
                        VStack {
                     Text("You chose ")
                     .font(.title)
                     .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    + Text(self.answer.expected)
                     .font(.title)
                     .fontWeight(.semibold)
                     .foregroundColor(Color.darkBlue)
                    + Text(",")
                    .font(.title)
                    .fontWeight(.semibold)
                        .foregroundColor(.white)
                     Text("the correct answer.")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    }
                  }
                } else {
                 HStack {
                 Text("The correct answer is")
                     .font(.title)
                     .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                Text(self.answer.expected)
                     .font(.title)
                     .fontWeight(.semibold)
                     .foregroundColor(Color.darkBlue)
                 + Text(".")
                     .font(.title)
                     .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    }
             HStack {
                 Text("You chose")
                     .font(.title)
                     .fontWeight(.semibold)
                .foregroundColor(Color.white)
                Text(self.answer.received)
                     .font(.title)
                     .fontWeight(.semibold)
                     .foregroundColor(Color.enemyRed)
                 + Text(".")
                     .font(.title)
                     .fontWeight(.semibold)
                .foregroundColor(Color.white)
                    }
                }
                Text("You answered in \(self.answer.time, specifier: "%.1f") seconds.")
                    .foregroundColor(Color.white)
                Text("(This is a \(self.answer.vehicleName))")
                    .foregroundColor(Color.white)
            }.onAppear {
                self.back = true
            }.onDisappear {
                self.back = false
            }
        )
    }
}

struct SummaryDetail_Previews: PreviewProvider {
    static var previews: some View {
        SummaryDetail(answer: Answer(id: 1, expected: "foe", received: "foe", image: "tank1", vehicleName: "tank1"), back: Binding.constant(true))
    }
}
