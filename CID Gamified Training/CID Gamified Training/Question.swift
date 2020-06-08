//
//  Question.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Question: View {
    // From: https://higginsweb.psych.columbia.edu/wp-content/uploads/2018/07/RFQ.pdf
    let questions = [
        "Compared to most people, are you typically unable to get what you want out of life?",
        "Growing up, would you ever “cross the line” by doing things that your parents would not tolerate?",
        "How often have you accomplished things that got you \"psyched\" to work even harder?",
        "Did you get on your parents’ nerves often when you were growing up?",
        "How often did you obey rules and regulations that were established by your parents?",
        "Growing up, did you ever act in ways that your parents thought were objectionable?",
        "Do you often do well at different things that you try?",
        "Not being careful enough has gotten me into trouble at times",
        "When it comes to achieving things that are important to me, I find that I don't perform as well as I ideally would like to do.",
        "I feel like I have made progress toward being successful in my life.",
        "I have found very few hobbies or activities in my life that capture my interest or motivate me to put effort into them."
        ]
    let responseDescription = [["never or seldom", "sometimes", "very often"],
                               ["never or seldom", "sometimes", "very often"],
                               ["never or seldom", "a few times", "many times"],
                               ["never or seldom", "sometimes", "very often"],
                               ["never or seldom", "sometimes", "always"],
                               ["never or seldom", "sometimes", "very often"],
                               ["never or seldom", "sometimes", "very often"],
                               ["never or seldom", "sometimes", "very often"],
                               ["never true", "sometimes true", "very often true"],
                               ["certainly false", " ", "certainly true"],
                               ["certainly false", " ", "certainly true"]
    ]
    
    @State private var responses: [Int] = []
    @State private var questionCount = 0
    @State private var curResponse = 3.0
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(questions[questionCount])
                    .font(.headline)
                    .padding([.leading, .bottom, .trailing])
                Spacer()
                HStack {
                    Slider(value: $curResponse, in: 1...5, step: 1)
                    .padding([.horizontal])
                }
                Text("\(Int(curResponse))")
                Text("\(getResponseDescription())")
                Spacer()
            }
            .navigationBarTitle(Text("Quiz")
            .font(.largeTitle))
        }
        .padding()
        
    }
    
    
    func answered(_ ans: Int) {
        self.responses.append(ans)
        print(ans)
        nextQuestion()
    }
    
    func nextQuestion() {
        questionCount += 1
    }
    
    func intCurResponse() -> Int {
        return Int(curResponse)
    }
    
    func getResponseDescription() -> String {
        let responseAsInt = intCurResponse()
        if responseAsInt == 1 {
            return responseDescription[questionCount][0]
        } else if responseAsInt == 3 {
            return responseDescription[questionCount][1]
        } else if responseAsInt ==  5 {
            return responseDescription[questionCount][2]
        }
        
        return " "
    }
}

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        Question()
    }
}
