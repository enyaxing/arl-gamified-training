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
    let defaults = UserDefaults.standard
    
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

    @State private var responses: [Int: Int] = [:]
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

                    HStack {
                        Spacer()
                        Button(action: {
                            self.prevQuestion()
                        }) {
                            Text("Back")
                        }
                        Spacer()
                        Button(action: {
                            self.answered(self.intCurResponse())
                        }) {
                            Text("Next")
                        }
                        Spacer()
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
            let (promotionScore, preventionScore) = getScore()
            return Alert(title: Text("Congratulations on finishing the quiz!"), message: Text("Your promotion score is \(promotionScore) and your prevention score is \(preventionScore)."), dismissButton: .default(Text("Quit"))
            )
        }
    }


    /** When we receive an answer, record the response and give the user the next question. */
    func answered(_ ans: Int) {
        self.responses[questionCount] = ans
        nextQuestion()
    }

    /** Checks if we have reached the end of the quiz. If we are done, calculate and show the results. If not,
     go on to the next question. */
    func nextQuestion() {
        if isCompleted() {
            showFinishedAlert = true
        } else {
            questionCount += 1
        }
    }
    
    /** Goes back one question. */
    func prevQuestion() {
        if questionCount > 0 {
            questionCount -= 1
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
                let promotion = "promotion"
                let prevention = "prevention"
                let equal = "equal"
                let (promotionScore, preventionScore) = getScore()
            
                if promotionScore > preventionScore {
                    defaults.set(promotion, forKey: "focus")
                } else if promotionScore < preventionScore{
                    defaults.set(prevention, forKey: "focus")
                } else {
                    defaults.set(equal, forKey: "focus")
                }
                print(responses)
               return true
           }
           return false
    }


    func getScore() -> (Int, Int) {
        let r1: Int = responses[0]!
        let r2: Int = responses[1]!
        let r3: Int = responses[2]!
        let r4: Int = responses[3]!
        let r5: Int = responses[4]!
        let r6: Int = responses[5]!
        let r7: Int = responses[6]!
        let r8: Int = responses[7]!
        let r9: Int = responses[8]!
        let r10: Int = responses[9]!
        let r11: Int = responses[10]!
        
        let promotionScore = ((6 - r1) + r3 + r7 + (6 - r9) + r10 + (6 - r11)) / 6
        let preventionScore = ((6 - r2) + (6 - r3) + r5 + (6 - r6) + (6 - r8)) / 5
        return (promotionScore, preventionScore)
    }
    
}

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        Question()
    }
}
