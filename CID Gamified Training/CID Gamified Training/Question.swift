//
//  Question.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Question: View {
    var questions = [
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
    
    @State private var responses: [Int] = []
    @State private var questionCount = 0
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            VStack {
                Text(questions[questionCount])
                    .font(.headline)
                    .padding([.leading, .bottom, .trailing])
                HStack {
                    Button(action: {self.answered(1)}) {
                        Text("1")
                    }
                    Button(action: {self.answered(2)}) {
                        Text("2")
                    }
                    Button(action: {self.answered(3)}) {
                        Text("3")
                    }
                    Button(action: {self.answered(4)}) {
                        Text("4")
                    }
                    Button(action: {self.answered(5)}) {
                        Text("5")
                    }
                }
            }
            .navigationBarTitle(Text("Quiz")
            .font(.largeTitle))
        }
        
    }
    
    
    func answered(_ ans: Int) {
        self.responses.append(ans)
        print(ans)
        nextQuestion()
    }
    
    func nextQuestion() {
        questionCount += 1
    }
}

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        Question()
    }
}
