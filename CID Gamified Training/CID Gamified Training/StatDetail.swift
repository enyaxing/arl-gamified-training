//
//  StatDetail.swift
//  CID Gamified Training
//
//  Created by Alex on 7/14/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct StatDetail: View {
    
    @State var prevSessions: [String] = []
    @State var vehicleTime: [String: Double] = [:]
    @State var tagTime: [String: Double] = [:]
    @State var vehicleAccuracy: [String: Double] = [:]
    @State var tagAccuracy: [String: Double] = [:]
    @State var vehicleCount: [String: Double] = [:]
    @State var tagCount: [String: Double] = [:]
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    var body: some View {
        VStack {
            Text("Stat Details")
                .font(.largeTitle)
                .fontWeight(.black)
            Text("Accuracy")
                .font(.largeTitle)
            HStack{
                VStack {
                    Text("Vehicle")
                    List {
                        ForEach(self.vehicleAccuracy.sorted(by: { $0.value > $1.value }), id: \.key) {key, value in
                            StatView(name: key, num: value, type: 0)
                        }
                    }
                }
                VStack {
                    Text("Tag")
                    List {
                        ForEach(self.tagAccuracy.sorted(by: { $0.value > $1.value }), id: \.key) {key, value in
                            StatView(name: key, num: value, type: 0)
                        }
                    }
                }
                
            }
            Text("Average Time")
                .font(.largeTitle)
            HStack {
                VStack {
                    Text("Vehicle")
                    List {
                        ForEach(self.vehicleTime.sorted(by: { $0.value > $1.value}), id: \.key) {key, value in
                            StatView(name: key, num: value, type: 1)
                        }
                    }
                }
                VStack {
                    Text("Tag")
                    List {
                        ForEach(self.tagTime.sorted(by: { $0.value > $1.value }), id: \.key) {key, value in
                            StatView(name: key, num: value, type: 1)
                        }
                    }
                }
            }
        } .onAppear{
            self.getStats(sessions: self.prevSessions)
        }
    }
    
    func getStats(sessions: [String]) {
        let sess = self.db.document(self.user.uid).collection("sessions")
        let decoder = JSONDecoder()
        if let path = Bundle.main.url(forResource: "tags", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: path)
                let tags: [Tags] = try! decoder.decode([Tags].self, from: jsonData)
                for str in sessions {
                    let curr = sess.document(str).collection("answers")
                    curr.getDocuments() {(query, err) in
                        if err != nil {
                            print("Error getting docs.")
                        } else {
                            for document in query!.documents {
                                let name = document.get("vehicleName") as! String
                                if self.vehicleCount[name] == nil {
                                    self.vehicleCount[name] = 1
                                    self.vehicleTime[name] = document.get("time") as? Double
                                    if document.get("expected") as! String == document.get("received") as! String {
                                        self.vehicleAccuracy[name] = 1
                                    } else {
                                        self.vehicleAccuracy[name] = 0
                                    }
                                } else {
                                    self.vehicleCount[name]! += 1
                                    self.vehicleTime[name]! += document.get("time") as! Double
                                    if document.get("expected") as! String == document.get("received") as! String {
                                        self.vehicleAccuracy[name]! += 1
                                    }
                                }
                                
                                for tag in tags {
                                    if document.get("image") as! String == tag.image {
                                        for label in tag.tags {
                                            if self.tagCount[label] != nil {
                                                self.tagCount[label]! += 1
                                                self.tagTime[label]! += document.get("time") as! Double
                                            } else {
                                                self.tagCount[label] = 1
                                                self.tagTime[label] = document.get("time") as? Double
                                            }
                                            if document.get("expected") as! String == document.get("received") as! String {
                                                if self.tagAccuracy[label] != nil {
                                                    self.tagAccuracy[label]! += 1
                                                } else {
                                                    self.tagAccuracy[label] = 1
                                                }
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }
                    }
                    
                }
            } catch {
                print("Error reading json.")
            }
        }
    }
}

struct StatDetail_Previews: PreviewProvider {
    static var previews: some View {
        StatDetail().environmentObject(GlobalUser())
    }
}
