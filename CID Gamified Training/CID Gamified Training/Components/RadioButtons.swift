//
//  ProgressBar.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 8/11/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

/** 5 radio buttons that are selectable with labels underneath for level of agreement. */
struct RadioButtons: View {
    /** Stores the user's current selected response. */
    @Binding var curResponse: Int
    
    /** References the question that the user is currently on. */
    @Binding var questionCount: Int
    
    /** Description for each response as it varies by question. */
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
                                Circle().fill(self.curResponse == i ? Color.armyGreen : Color.white.opacity(0.8)).frame(width: 30, height: 35)
                                if self.curResponse == i{
                                    Circle().stroke(Color.white, lineWidth: 4).frame(width: 32, height: 25)
                                }
                            }
                            Text("\(i)")
                                .foregroundColor(Color.white)
                                .fontWeight(.semibold)
                        }
                        .frame(width: 50.0, height: 50)
                    }
                    .foregroundColor(.black)
                }
                .padding(.top)
            }
            
            HStack {
                Text(getResponseDescription(1))
                    .multilineTextAlignment(.center)
                    .padding(.trailing, 20.0)
                    .frame(width: 100.0)
                    .foregroundColor(Color.white)
                Text(getResponseDescription(3))
                    .multilineTextAlignment(.center)
                    .frame(width: 100.0)
                    .foregroundColor(Color.white)
                Text(getResponseDescription(5))
                    .multilineTextAlignment(.center)
                    .padding(.leading)
                    .frame(width: 100.0)
                    .foregroundColor(Color.white)
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