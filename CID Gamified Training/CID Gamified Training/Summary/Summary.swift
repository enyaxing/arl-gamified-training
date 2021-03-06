//
//  Summary.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/11/20.
//  Copyright © 2020 X-Force. All rights reserved.
//
import SwiftUI
import Firebase

/** The summary view after session completed. */
struct Summary: View {
    
    /** List of answers from completed training session. */
    @State var answers: [Answer]
    
    /** Firebase sessino reference. */
    var sess: String = ""
    
    /** Hide back button. */
    @State var hideback = false
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Show countdown. */
    @Binding var countdown: Bool
    
    /** UID of the user. */
    @State var uid: String = ""
    
    /** Records timestamp of when  the session is finished*/
    let endTime = Timestamp()
    
    /** Session object to be summarized. */
    @State var session: Session
    
    /** Comment about tag performance displayed on top of page. */
    @State var tagID = ""
    
    var body: some View {
        VStack {
            Text("Summary")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.white)
            Rectangle()
                .frame(height: 1.0, alignment: .bottom)
                .foregroundColor(Color.white)
                .offset(y: -15)
            Text("Session Type: \(self.session.type)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            if(self.user.regular != "neutral") {
                Text("Points: \(session.points)")
                    .font(.headingFont)
                    .foregroundColor(Color.white)
            }
            Group {
                if self.user.regular == "promotion" {
                    Text("Correct: \(countCorrect(answer: answers))/\(answers.count)")
                        .fontWeight(.bold)
                        .foregroundColor(Color.darkBlue)
                } else if self.user.regular == "prevention" {
                    Text("Incorrect: \(incorrect(answer: answers))/\(answers.count)")
                        .fontWeight(.bold)
                        .foregroundColor(Color.enemyRed)
                } else {
                    Text("Correct: \(countCorrect(answer: answers))")
                        .fontWeight(.bold)
                        .foregroundColor(Color.darkBlue)
                    Text("Incorrect: \(incorrect(answer: answers))")
                        .fontWeight(.bold)
                        .foregroundColor(Color.enemyRed)
                }
            }
            Text(tagID)
            List {
                ForEach(self.answers, id: \.id) {answer in
                    NavigationLink(destination: SummaryDetail(answer: answer, back: self.$hideback)) {
                        SummaryRow(answer: answer)
                    }
                }.listRowBackground(Color.lightBlack)
            }
        } .navigationBarBackButtonHidden(hideback)
            .onAppear{
                UITableView.appearance().backgroundColor = .clear
                if self.uid == "" {
                    self.uid = self.user.uid
                }
                if self.sess == "" {
                    let session = self.db.document(self.uid).collection("sessions")
                    self.updateStats(doc: self.db.document(self.uid))
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
                    self.tagID = readTags(answers: self.answers)
                    checkComplete(user: self.db.document(self.uid), uid: self.uid, percentage: percentage(answer: self.answers), timeInterval: self.endTime.dateValue().timeIntervalSince(self.session.timestamp.dateValue()))
                } else {
                    self.getAnswers(db: self.db.document(self.uid).collection("sessions").document(self.sess).collection("answers"))
                }
        }
        .onDisappear{
            if !self.hideback {
                self.countdown = true
            }
        }.background(Color.lightBlack.edgesIgnoringSafeArea(.all))
    }
    
    /** Get the list of answers of session from Firebase.
     Parameters:
        db - CollectionReference to answers collection in firebase. */
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
                self.tagID = readTags(answers: self.answers)
            }
        }
    }
    
    /** Update and save stats on Firebase.
     Parameters:
        doc - DocumentReference to user document in Firebase. */
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
                    self.user.totalSessions = prevTotalSessions + 1
                    doc.updateData(["totalSessions": self.user.totalSessions])
                    if document.get("avgResponseRate") != nil {
                        let prevAvgResponseRate: Double = document.get("avgResponseRate") as! Double
                        var curSumResponseTime: Double = 0.00
                        for ans in self.answers {
                            curSumResponseTime += ans.time
                        }
                        let curAvgResponseTime: Double = curSumResponseTime / 20
                        self.user.avgResponseTime = (prevAvgResponseRate * Double(prevTotalSessions) + curAvgResponseTime) / Double(self.user.totalSessions)
                        doc.updateData(["avgResponseRate": self.user.avgResponseTime])
                    } else {
                        var curSumResponseTime: Double = 0.00
                        for ans in self.answers {
                            curSumResponseTime += ans.time
                        }
                        self.user.avgResponseTime = curSumResponseTime / 20
                        doc.updateData(["avgResponseRate": self.user.avgResponseTime])
                    }
                    if document.get("accuracy") != nil {
                        let prevAccuracy: Double = document.get("accuracy") as! Double
                        let numCorrect = countCorrect(answer: self.answers)
                        self.user.accuracy = Double(prevAccuracy * Double(prevTotalSessions) + Double(numCorrect) / 20) / Double(self.user.totalSessions)
                        doc.updateData(["accuracy": self.user.accuracy])
                    } else {
                        let numCorrect = countCorrect(answer: self.answers)
                        self.user.accuracy = Double(numCorrect / 20)
                        doc.updateData(["accuracy": self.user.accuracy])
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

/** Count the number of correct answers.
 Parameters:
    answer - List of answers for this summary.
 Return:
    Int representing number of correct answers. */
func countCorrect(answer: [Answer]) -> Int {
    var count = 0
    for ans in answer {
        if ans.expected == ans.received {
            count += 1
        }
    }
    return count
}

/** Count the number of incorrect answers.
 Parameters:
    answer - List of answers for this summary.
 Return:
    Int representing number of incorrect answers. */
func incorrect(answer: [Answer]) -> Int {
    return answer.count - countCorrect(answer: answer)
}

/** Calculate percentage of correct answers.
 Parameters:
    answer - List of answers for this summary.
 Return:
    List of Doubles of length 2.
    Double[0] = percentage of friendly correct.
    Double[1] = percentage of enemy correct. */
func percentage(answer: [Answer]) -> [Double] {
    var friend: [Answer] = []
    var foe: [Answer] = []
    for ans in answer {
        if ans.expected == "friendly" {
            friend.append(ans)
        } else if ans.expected == "foe" {
            foe.append(ans)
        }
    }
    let first = ((Double(countCorrect(answer: friend)) / Double(friend.count)) * 100.0)
    let second = ((Double(countCorrect(answer: foe)) / Double(foe.count)) * 100.0)
    return [first, second]
}

/** Parse image reference to be saved on Firebase.
 Parameters:
    location - String representing complete file path.
 Return:
    String representing part of the file path starting with CID Images. */
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

/** Parse question id to be saved on Firebase.
 Parameters:
    id - Int representing question number 0-19
 Return:
    2 digit String from 01-20 */
func parseID(id: Int) -> String {
    let title = id + 1
    if title < 10 {
        return "0\(title)"
    } else {
        return "\(title)"
    }
}

/** Generates tag comments based on list of answers.
 Parameter:
    answers - List of answers
 Return:
    String representing the comment to be displayed. */
func readTags(answers: [Answer]) -> String {
    let decoder = JSONDecoder()
    var ret = ""
    if let path = Bundle.main.url(forResource: "tags", withExtension: "json") {
        do {
            let jsonData = try Data(contentsOf: path)
            let tags: [Tags] = try! decoder.decode([Tags].self, from: jsonData)
            var countTags = [String:Int]()
            var incTags = [String:Int]()
            for ans in answers {
                for tag in tags {
                    if parseImage(location: ans.image) == tag.image {
                        for label in tag.tags {
                            if countTags[label] != nil {
                                countTags[label]! += 1
                            } else {
                                countTags[label] = 1
                            }
                            if ans.expected != ans.received {
                                if incTags[label] != nil {
                                    incTags[label]! += 1
                                } else {
                                    incTags[label] = 1
                                }
                            }
                        }
                        break
                    }
                }
            }
            for (key, _) in incTags {
                if incTags[key]! >= countTags[key]! / 2 {
                    ret += "You struggle with \(key) images.\n"
                }
            }
        } catch {
            print("Error reading json.")
        }
    }
    return ret
}

func checkComplete(user: DocumentReference, uid: String, percentage: [Double], timeInterval: Double) {
    user.getDocument { (document, error) in
        if let document = document, document.exists {
            if document.get("class") != nil {
                let cla = document.get("class") as! DocumentReference
                let assignment = cla.collection("assignments")
                var modelFriends: [String] = []
                var modelEnemies: [String] = []
                for card in Model.friendlyFolder {
                    modelFriends.append(card.name)
                }
                for card in Model.enemyFolder {
                    modelEnemies.append(card.name)
                }
                modelFriends.sort()
                modelEnemies.sort()
                assignment.getDocuments() {(query, err) in
                    if err != nil {
                        print("Error getting docs.")
                    } else {
                        for document in query!.documents {
                            if document.get("friendly") != nil && document.get("enemy") != nil{
                                var friends = document.get("friendly") as! [String]
                                var enemies = document.get("enemy") as! [String]
                                friends.sort()
                                enemies.sort()
                                let friendlyAccuracy = document.get("friendlyAccuracy") as! Double
                                let enemyAccuracy = document.get("enemyAccuracy") as! Double
                                let time = document.get("time") as! Double
                                if percentage[0] >= friendlyAccuracy && percentage[1] >= enemyAccuracy && time <= time && modelFriends == friends && modelEnemies == enemies {
                                    assignment.document(document.documentID).updateData(["completed": FieldValue.arrayUnion([uid])])
                                }
                            }
                        }
                    }
                }
            }
        } else {
            print("Document does not exist")
        }
    }
}

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary(answers: [Answer(id: 1, expected: "foe", received: "foe", image: "tank1", vehicleName: "tank1")], countdown: Binding.constant(false), session: Session(points: 0, timestamp: Timestamp(), type: "Forced Choice")).environmentObject(GlobalUser())
    }
}
