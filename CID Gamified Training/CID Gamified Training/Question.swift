//
//  Question.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI
import Surge

enum ActiveAlert {
    case showFinishedAlert, alreadyCompletedAlert, noAnswerSelectedAlert
}

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

    /** Dictionary mapping of responses. Key = question number, value = response value. */
    @State private var responses: [Int: Int] = [:]

    /** Integer that keeps track of which question the user is on. */
    @State private var questionCount:Int = 0

    /** Integer that tracks the user's current response. */
    @State var curResponse: Int

    /** Boolean that determines whether an alert should be shown or not. */
    @State private var showAlert: Bool = false

    /** Sets the default activeAlert. */
    @State private var activeAlert: ActiveAlert = .alreadyCompletedAlert

    /** Used to pass regulatory focus type to other views. */
    @Binding var regular: String

    /** Environment variable used to dismiss view. */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            Spacer()
            Text(questions[questionCount])
                .font(.title)
                .padding([.leading, .bottom, .trailing])
            Spacer()
            RadioButtons(curResponse: $curResponse)
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
                    self.answered(self.curResponse)
                }) {
                    Text("Next")
                }
                Spacer()
            }
            .padding(.bottom)

            Text("\(questionCount + 1) out of \(questions.count)")
            Spacer()
    }
    .navigationBarTitle(Text("Quiz")
    .font(.largeTitle))
    .padding()

    .alert(isPresented: $showAlert) {

        switch activeAlert {
            case .alreadyCompletedAlert:
                return Alert(title: Text("Warning"), message: Text("You've already completed the quiz. Would you like to retake it?"), primaryButton: .default(Text("No"), action: {self.presentationMode.wrappedValue.dismiss()}),secondaryButton: .default(Text("Yes"), action: {self.defaults.set(nil, forKey: "focus")}))
            case .showFinishedAlert:
                let (promotionScore, preventionScore) = getScore()
                return Alert(title: Text("Congratulations on finishing the quiz!"), message: Text("Your promotion score is \(promotionScore) and your prevention score is \(preventionScore)."), dismissButton: .default(Text("Quit"), action: {self.presentationMode.wrappedValue.dismiss()}))
            case .noAnswerSelectedAlert:
                return Alert(title: Text("Error"), message: Text("Please select an answer choice to continue"), dismissButton: .default(Text("Okay")))

            }
        }
        .onAppear() {
            self.isAlreadyCompleted()
        }

    }

    /** When we receive an answer, record the response and give the user the next question. */
    func answered(_ ans: Int) {
        if ans == 0 {
            activeAlert = .noAnswerSelectedAlert
            showAlert = true
        } else {
            self.responses[questionCount] = ans
            nextQuestion()
        }
    }

    /** Checks if we have reached the end of the quiz. If we are done, calculate and show the results. If not,
     go on to the next question. */
    func nextQuestion() {
        if isCompleted() {
            activeAlert = .showFinishedAlert
            showAlert = true
        } else {
            questionCount += 1
            curResponse = 0
        }
    }

    /** Goes back one question. */
    func prevQuestion() {
        if questionCount > 0 {
            questionCount -= 1
            curResponse = responses[questionCount]!
        }
    }

    /** Returns the correct response description based on current response. Based on responseDescription values.*/
    func getResponseDescription() -> String {
        if curResponse == 1 {
            return responseDescription[questionCount][0]
        } else if curResponse == 3 {
            return responseDescription[questionCount][1]
        } else if curResponse ==  5 {
            return responseDescription[questionCount][2]
        }

        return " "
    }

    /** Checks whether the quiz has already been completed. */
    func isAlreadyCompleted() {
        if questionCount == 0 {
            if self.regular != "None" {
                activeAlert = .alreadyCompletedAlert
                showAlert = true
            }
        }
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
                self.regular = focus(defaults: defaults)
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
        let preventionScore = ((6 - r2) + (6 - r4) + r5 + (6 - r6) + (6 - r8)) / 5
        return (promotionScore, preventionScore)
    }

//    func calculate() ->[[Double]] {
//        var pre_cnt: Int
//        var pro_cnt: Int
//
//        var pre: Double
//        var pro: Double
//
//        let r1: Int = responses[0]!
//        let r2: Int = responses[1]!
//        let r3: Int = responses[2]!
//        let r4: Int = responses[3]!
//        let r5: Int = responses[4]!
//        let r6: Int = responses[5]!
//        let r7: Int = responses[6]!
//        let r8: Int = responses[7]!
//        let r9: Int = responses[8]!
//        let r10: Int = responses[9]!
//        let r11: Int = responses[10]!
//
//        let B: Matrix<Double> = [1.565563, -0.502494, -0.112472, -6.720915, -2.630483, 1.413550, 0.676953, 0.641702, 0.282040]
//
//        var T = 0.677422
//
//        if pre_cnt == 6 {
//            pre = 3.0
//        } else {
//            pre = ((6 - r1) + r3 + r7 + (6 - r9) + r10 + (6 - r11)) / (6 - pre_cnt)
//        }
//
//        if pro_cnt == 5 {
//            pro = 3.6
//        } else {
//            pro = ((6 - r2) + (6 - r4) + r5 + (6 - r6) + (6 - r8)) / (5 - pro_cnt)
//        }
//
//        var MSE = 0.953010
//
//        let iCovX: Matrix<Double> = [
//        [    0.8873,   -0.0740,   -0.1814,   -0.8873,   -0.8873,    0.0740,    0.1814,    0.0740,    0.1814],
//        [   -0.0740,    0.0494,   -0.0166,    0.0740,    0.0740,   -0.0494,    0.0166,   -0.0494,    0.0166],
//        [   -0.1814,   -0.0166,    0.0627,    0.1814,    0.1814,    0.0166,   -0.0627,    0.0166,   -0.0627],
//        [   -0.8873,    0.0740,    0.1814,    3.9430,    0.8873,   -0.3611,   -0.7339,   -0.0740,   -0.1814],
//        [   -0.8873,    0.0740,    0.1814,    0.8873,    2.7615,   -0.0740,   -0.1814,   -0.3327,   -0.4982],
//        [    0.0740,   -0.0494,    0.0166,   -0.3611,   -0.0740,    0.1104,    0.0048,    0.0494,   -0.0166],
//        [    0.1814,    0.0166,   -0.0627,   -0.7339,   -0.1814,    0.0048,    0.1923,   -0.0166,    0.0627],
//        [    0.0740,   -0.0494,    0.0166,   -0.0740,   -0.3327,    0.0494,   -0.0166,    0.1119,    0.0068],
//        [    0.1814,   0.0166 ,   -0.0627,   -0.1814,   -0.4982,   -0.0166,    0.0627,    0.0068,    0.1342 ]]
//
//        var scores: [[Double]] = [
//        [0, 0, 0],
//        [0, 0, 0],
//        [0, 0, 0]]
//
//        var X0: Matrix<Double> = [1, pre, pro, 0, 1, 0, 0, pre, pro]
//        temp = T * sqrt(MSE * (1 + transpose(X0) * (iCovX * X0)))
//        scores[0][0] = transpose(X0) * B
//        scores[0][1] = csores[0][0] - temp
//        scores[0][2] = scores[0][0] + temp
//
//        var X1: Matrix<Double> = [ 1, pre, pro, 1, 0, pre, pro, 0, 0]
//        temp = T * sqrt(MSE * (1 + transpose(X0) * (iCovX * X0)))
//        scores[1][0] = transpose(X1) * B
//        scores[1][1] = scores[1][0] - temp
//        scores[1][2] = scores [1][0] + temp
//
//        var X2: Matrix<Double> = [1, pre, pro, 0, 0, 0, 0, 0, 0]
//        temp = T * sqrt(MSE * (1 + transpose(X2) * (iCovX * X0)))
//        scores[2][0] = transpose(X0) * B
//        scores[2][1] = scores[2][0] - temp
//        scores[2][2] = scores [2][0] + temp
//
//        return scores
//    }
}

struct RadioButtons: View {
    @Binding var curResponse: Int
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) {i in
                Button(action: {
                    self.curResponse = i
                }) {
                    VStack {
                        ZStack{
                            Circle().fill(self.curResponse == i ? Color.blue : Color.black.opacity(0.2)).frame(width: 20, height: 25)
                            if self.curResponse == i{
                                Circle().stroke(Color.blue, lineWidth: 4).frame(width: 32, height: 25)
                            }
                        }
                        Text("\(i)")
                    }
                }
                .padding(.horizontal, 8.0)
                .foregroundColor(.black)
            }
            .padding(.top)
        }
    .cornerRadius(30)
    }
}

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        Question(curResponse: 0, regular: ContentView().$regular)
    }
}
