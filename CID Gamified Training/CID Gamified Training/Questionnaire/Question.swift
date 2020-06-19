//
//  Question.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI
import Surge
import Firebase

enum ActiveAlert {
    case showFinishedAlert, alreadyCompletedAlert, noAnswerSelectedAlert
}

struct Question: View {
    // From: https://higginsweb.psych.columbia.edu/wp-content/uploads/2018/07/RFQ.pdf
    
    /** Connection to firebase users collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: User

    /** List of questions. */
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

    /** Environment variable used to dismiss view. */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            Spacer()
            Text(questions[questionCount])
                .font(.title)
                .padding([.leading, .bottom, .trailing])
                .frame(height: 250.0)
            Spacer()
            RadioButtons(curResponse: $curResponse, questionCount: $questionCount)
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
            Spacer()
            Text("\(questionCount + 1) out of \(questions.count)")
            Spacer()
    }
    .navigationBarTitle(Text("Quiz")
    .font(.largeTitle))
    .padding()

    .alert(isPresented: $showAlert) {
        switch activeAlert {
            case .alreadyCompletedAlert:
                return Alert(title: Text("Warning"), message: Text("You've already completed the quiz. Would you like to retake it?"), primaryButton: .default(Text("No"), action: {self.presentationMode.wrappedValue.dismiss()}),secondaryButton: .default(Text("Yes"), action: {self.db.document(self.user.uid).setData(["focus": "None"], merge: true)
                    self.user.regular = "None"
                }))
            case .showFinishedAlert:
                let (pre, pro) = calculateScore()
                return Alert(title: Text("Congratulations on finishing the quiz!"), message: Text("Your prevention score is: \(String(format: "%.3f", pre)).\nYour promotion score is \(String(format: "%.3f", pro)).\nWe have determined your best focus type is \(self.user.regular)."), dismissButton: .default(Text("Quit"), action: {self.presentationMode.wrappedValue.dismiss()}))
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

    /** Checks whether the quiz has already been completed. */
    func isAlreadyCompleted() {
        if questionCount == 0 {
            if self.user.regular != "None" {
                activeAlert = .alreadyCompletedAlert
                showAlert = true
            }
        }
    }

    /** Checks if we have finished the quiz. */
    func isCompleted() -> Bool{
           if questionCount == (questions.count - 1){
                analyzeScore()
                return true
           }
           return false
    }

    /** Calculates which regulatory focus type will be most beneficial to the user. Returns the type as either preventino, promotion, or neutral. */
    func analyzeScore() -> () {
        let (pre, pro) = calculateScore()
        let scores: [[Double]] = calculateIntervals(pre, pro)
        
        let promotion = scores[0][0]
        let prevention = scores[1][0]
        let control = scores[2][0]
        
        let maxVal = max(prevention, promotion, control)
        var selected: String
        if  maxVal == prevention {
            selected = "prevention"
        } else if maxVal == promotion {
            selected = "promotion"
        } else {
            selected = "neutral"
        }
        db.document(self.user.uid).setData(["focus": selected], merge: true)
        self.user.regular = selected
    }
    
    /** Heuristic from Dr. Benjamin Files. Modified from Python to Swift.
            Outputs: Prevention score, promotion score, confidence interval array*/
    func calculateScore() -> (Double, Double) {
        /** Response for prevention: 1.0, promotion: 5.0 score: [5, 1, 1, 1, 5, 1, 1, 1, 5, 1, 5]*/
        /** Response for prevention: 5.0, promotion: 1.0 score: [1, 5, 5, 5, 1, 5, 5, 5, 1, 5, 1]*/
        var pre: Double
        var pro: Double
        
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

        let pre_part1: Double = Double((6 - r1) + r3 + r7)
        let pre_part2: Double = Double((6 - r9) + r10 + (6 - r11))
        pre = (pre_part1 + pre_part2) / (6)
        
        let pro_part1: Double = Double((6 - r2) + (6 - r4) + r5)
        let pro_part2: Double = Double((6 - r6) + (6 - r8))
        pro = (pro_part1 + pro_part2) / 5
        return (pre, pro)
    }
    
    func calculateIntervals(_ pre: Double, _ pro: Double) -> [[Double]] {
        let B: Matrix<Double> = [[1.565563, -0.502494, -0.112472, -6.720915, -2.630483, 1.413550, 0.676953, 0.641702, 0.282040]]
        let T = 0.677422
        
        let MSE = 0.953010
        
        let iCovX: Matrix<Double> = [
        [    0.8873,   -0.0740,   -0.1814,   -0.8873,   -0.8873,    0.0740,    0.1814,    0.0740,    0.1814],
        [   -0.0740,    0.0494,   -0.0166,    0.0740,    0.0740,   -0.0494,    0.0166,   -0.0494,    0.0166],
        [   -0.1814,   -0.0166,    0.0627,    0.1814,    0.1814,    0.0166,   -0.0627,    0.0166,   -0.0627],
        [   -0.8873,    0.0740,    0.1814,    3.9430,    0.8873,   -0.3611,   -0.7339,   -0.0740,   -0.1814],
        [   -0.8873,    0.0740,    0.1814,    0.8873,    2.7615,   -0.0740,   -0.1814,   -0.3327,   -0.4982],
        [    0.0740,   -0.0494,    0.0166,   -0.3611,   -0.0740,    0.1104,    0.0048,    0.0494,   -0.0166],
        [    0.1814,    0.0166,   -0.0627,   -0.7339,   -0.1814,    0.0048,    0.1923,   -0.0166,    0.0627],
        [    0.0740,   -0.0494,    0.0166,   -0.0740,   -0.3327,    0.0494,   -0.0166,    0.1119,    0.0068],
        [    0.1814,   0.0166 ,   -0.0627,   -0.1814,   -0.4982,   -0.0166,    0.0627,    0.0068,    0.1342 ]]
        
        var scores: [[Double]] = [
            [0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0]]
        
//        gain case 1
        let X0: Matrix<Double> = [[1, pre, pro, 0, 1, 0, 0, pre, pro]]
        let temp1 = (X0 * iCovX) * transpose(X0)
        let temp2 = T * sqrt(MSE * (1 + temp1[0][0]))
        scores[0][0] = (B * transpose(X0))[0][0]
        scores[0][1] = Double(scores[0][0] - temp2)
        scores[0][2] = Double(scores[0][0] + temp2)
        
//        loss case 2
        let X1: Matrix<Double> = [[ 1, pre, pro, 1, 0, pre, pro, 0, 0]]
        let temp3 = (X1 * iCovX) * transpose(X1)
        let temp4 = T * sqrt(MSE * (1 + temp3[0][0]))
        scores[1][0] = (B * transpose(X1))[0][0]
        scores[1][1] = scores[1][0] - temp4
        scores[1][2] = scores [1][0] + temp4
        
//        control case 3
        let X2: Matrix<Double> = [[1, pre, pro, 0, 0, 0, 0, 0, 0]]
        let temp5 = (X2 * iCovX) * transpose(X2)
        let temp6 = T * sqrt(MSE * (1 + temp5[0][0]))
        scores[2][0] = (B * transpose(X2))[0][0]
        scores[2][1] = scores[2][0] - temp6
        scores[2][2] = scores [2][0] + temp6
        
        return scores
    }
}

struct RadioButtons: View {
    @Binding var curResponse: Int
    @Binding var questionCount: Int
    
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
    
    var body: some View {
        VStack {
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
                                .fontWeight(.semibold)
                        }
                        .frame(width: 50.0, height: 50)
                    }
    //                .padding(.horizontal, 8.0)
                    .foregroundColor(.black)
                }
                .padding(.top)
            }
            
            HStack {
                Text(getResponseDescription(1))
                    .multilineTextAlignment(.center)
                    .padding(.trailing, 20.0)
                    .frame(width: 100.0)
                Text(getResponseDescription(3))
                    .multilineTextAlignment(.center)
                    .frame(width: 100.0)
                Text(getResponseDescription(5))
                    .multilineTextAlignment(.center)
                    .padding(.leading)
                    .frame(width: 100.0)
            }
            .padding(.top)
            
        }
    }
    
    /** Returns the correct response description based on current response. Based on responseDescription values.*/
    func getResponseDescription(_ num: Int) -> String {
        if num == 1 {
            return responseDescription[questionCount][0]
        } else if num == 3 {
            return responseDescription[questionCount][1]
        } else if num ==  5 {
            return responseDescription[questionCount][2]
        }
        return " "
    }
}

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        Question(curResponse: 0).environmentObject(User())
    }
}
