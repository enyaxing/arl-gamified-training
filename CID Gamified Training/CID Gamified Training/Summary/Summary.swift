//
//  Summary.swift
//  CID Gamified Training
//
//  Created by Alex on 6/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI
import Firebase

/** The summary view after session completed. */
struct Summary: View {
    
    /** List of answers from completed training session. */
    @State var answers: [Answer]
    
    var sess: String = ""
    
    @State var hideback = false
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
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
            .onAppear{
                if self.sess == "" {
                    let session = self.db.document(self.user.uid).collection("sessions")
                    let time = Timestamp()
                    session.document(time.description).setData(["time": time])
                    let answer = session.document(time.description).collection("answers")
                    for ans in self.answers {
                        answer.document("Question #\(ans.id)").setData([
                            "id": ans.id,
                            "expected": ans.expected,
                            "received": ans.received,
                            "image": "tank1",
                            "vehicleName": ans.vehicleName,
                            "time": ans.time
                        ])
                    }
                } else {
                    self.getAnswers(db: self.db.document(self.user.uid).collection("sessions").document(self.sess).collection("answers"))
                }
                
        }
        .onDisappear{
            if !self.hideback {
                self.countdown = true
            }
        }
    }
    func getAnswers(db: CollectionReference) {
        var ret: [Answer] = []
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                for document in query!.documents {
                    ret.append(Answer(
                        id: document.get("id") as! Int,
                        expected: document.get("expected") as! String,
                        received: document.get("received") as! String,
                        image: document.get("image") as! String,
                        vehicleName: document.get("vehicleName") as! String,
                        time: document.get("time") as! Double
                    ))
                }
                self.answers = ret
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
