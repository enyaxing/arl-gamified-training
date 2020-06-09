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
    @State private var showFinishedAlert = false
    
    var body: some View {
        HStack {
            NavigationView {
                VStack {
                    Spacer()
                    Text(questions[questionCount])
                        .font(.title)
                        .padding([.leading, .bottom, .trailing])
                    Spacer()
                    HStack {
                        Slider(value: $curResponse, in: 1...5, step: 1)
                        .padding([.horizontal])
                    }
                    Text("\(Int(curResponse))")
                    Text("\(getResponseDescription())")
                    Spacer()
                    
                    Button(action: {
                        self.answered(self.intCurResponse())
                    }) {
                        Text("Next")
                    }
                    
                    Text("\(questionCount + 1) out of \(questions.count)")
                    Spacer()
                }
                .navigationBarTitle(Text("Quiz")
                .font(.largeTitle))
            }
            .padding()
        }
        .alert(isPresented: $showFinishedAlert) {
            Alert(title: Text("Congratulations on finishing the quiz!"), message: Text("Your promotion score is \(getPromotionScore()) and your prevention score is \(getPreventionScore())."), dismissButton: .default(Text("Let's get to training!")))
        }
    }
    
    
    /** When we receive an answer, record the response and give the user the next question. */
    func answered(_ ans: Int) {
        self.responses.append(ans)
        nextQuestion()
    }
    
    /** Checks if we have reached the end of the quiz. If we are done, calculate and show the results. If not,
     go on to the next question. */
    func nextQuestion() {
        if isCompleted() {
            showFinishedAlert = true
        } else {
            questionCount += 1
            print(questionCount)
        }
    }
    
    /** Returns the current repsonse as an integer. */
    func intCurResponse() -> Int {
        return Int(curResponse)
    }
    
    /** Returns the correct response description based on current response. Based on responseDescription values.*/
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
    
    /** Checks if we have finished the quiz. */
    func isCompleted() -> Bool{
           if questionCount == (questions.count - 1){
               return true;
           }
           return false;
    }
       
    
    func getPromotionScore() -> Int {
        return ((6 - responses[0]) + responses[2] + responses[6] + (6 - responses[8]) + responses[9] + (6 - responses[10])) / 6
    }
    
    func getPreventionScore() -> Int {
        return ((6 - responses[1]) + (6 - responses[3]) + responses[4] + (6 - responses[5]) + (6 - responses[7]))
    }
}

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        Question()
    }
}
