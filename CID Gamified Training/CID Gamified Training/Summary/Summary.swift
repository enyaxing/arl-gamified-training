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
    
    @State var uid: String = ""
    
    /** Records timestamp of when  the session is finished*/
    let endTime = Timestamp()

    /** Points earned from the session. */
//    @Binding var points: Int
    
    @State var session: Session
    
    var body: some View {
        VStack {
            Text("Summary")
            .font(.largeTitle)
            .fontWeight(.black)
            Text("Session Type: \(self.session.type)")
                .font(.headline)
                .fontWeight(.bold)
            if(self.user.regular != "neutral") {
                Text("Points: \(session.points)")
                    .font(.headingFont)
            }
            
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
                if self.uid == "" {
                    self.uid = self.user.uid
                }
                if self.sess == "" {
                    let session = self.db.document(self.uid).collection("sessions")
                    self.updateStats(doc: self.db.document(self.uid))
                    // Fix this timestamp
                    let time = self.session.timestamp
                    session.document(time.description).setData(["points": self.session.points, "time": time, "type": self.session.type])
                    let answer = session.document(time.description).collection("answers")
                    for ans in self.answers {
                        let img = parseImage(location: ans.image)
                        answer.document("Question #\(parseID(id: ans.id))").setData([
                            "id": ans.id,
                            "expected": ans.expected,
                            "received": ans.received,
                            "image": img,
                            "vehicleName": ans.vehicleName,
                            "time": ans.time
                        ])
                    }
                    
                } else {
                    self.getAnswers(db: self.db.document(self.uid).collection("sessions").document(self.sess).collection("answers"))
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
                let path = Bundle.main.resourcePath!
                for document in query!.documents {
                    ret.append(Answer(
                        id: document.get("id") as! Int,
                        expected: document.get("expected") as! String,
                        received: document.get("received") as! String,
                        image: path + (document.get("image") as! String),
                        vehicleName: document.get("vehicleName") as! String,
                        time: document.get("time") as! Double
                    ))
                }
                self.answers = ret
            }
        }
    }
    
    func updateStats(doc: DocumentReference) {
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("totalTime") != nil {
                    let prevTotalTime: TimeInterval = document.get("totalTime") as! TimeInterval
                    let timeInterval = self.endTime.dateValue().timeIntervalSince(self.session.timestamp.dateValue())
                    self.user.totalTime = prevTotalTime + timeInterval
                    doc.updateData(["totalTime": self.user.totalTime])
                }
                
                if document.get("totalSessions") != nil {
                    let prevTotalSessions: Int = document.get("totalSessions") as! Int
                    let updatedTotalSessions = prevTotalSessions + 1
                    doc.updateData(["totalSessions": updatedTotalSessions])
                    
                    if document.get("avgResponseRate") != nil {
                        let prevAvgResponseRate: Double = document.get("avgResponseRate") as! Double
                        var curSumResponseTime: Double = 0.00
                        for ans in self.answers {
                            curSumResponseTime += ans.time
                        }
                        
                        let curAvgResponseTime: Double = curSumResponseTime / 20
                        
                        let updatedResponseTime: Double = (prevAvgResponseRate * Double(prevTotalSessions) + curAvgResponseTime) / Double(updatedTotalSessions)
                        
                        doc.updateData(["avgResponseRate": updatedResponseTime])
    
                    } else {
                        var curSumResponseTime: Double = 0.00
                        for ans in self.answers {
                            curSumResponseTime += ans.time
                        }
                        let curAvgResponseTime: Double = curSumResponseTime / 20
                        doc.add(["avgResponseRate": curAvgResponseTime])
                    }
                }
                
            } else {
                print("Document does not exist")
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

func parseImage(location: String) -> String {
    var count = 3
    var charCount = 0
    for i in (0..<location.count).reversed() {
        if Array(location)[i] == "/" {
            count -= 1
        }
        charCount += 1
        if count == 0 {
            break
        }
    }
    return String(location.suffix(charCount))
}

func parseID(id: Int) -> String {
    let title = id + 1
    if id < 10 {
        return "0\(title)"
    } else {
        return "\(title)"
    }
}

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary(answers: [Answer(id: 1, expected: "foe", received: "foe", image: "tank1", vehicleName: "tank1")], countdown: Binding.constant(false), session: Session(points: 0, timestamp: Timestamp(), type: "Forced Choice")).environmentObject(GlobalUser())
    }
}
