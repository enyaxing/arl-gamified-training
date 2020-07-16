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
    
    @State var vehiclePercent: [String: Double] = [:]
    @State var tagPercent: [String: Double] = [:]
    @State var vehicleSecond: [String: Double] = [:]
    @State var tagSecond: [String: Double] = [:]
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    var uid: String
    
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
                        ForEach(self.vehiclePercent.sorted(by: { $0.value > $1.value }), id: \.key) {key, value in
                            StatView(name: key, num: value, type: 0)
                        }
                    }
                }
                VStack {
                    Text("Tag")
                    List {
                        ForEach(self.tagPercent.sorted(by: { $0.value > $1.value }), id: \.key) {key, value in
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
                        ForEach(self.vehicleSecond.sorted(by: { $0.value > $1.value}), id: \.key) {key, value in
                            StatView(name: key, num: value, type: 1)
                        }
                    }
                }
                VStack {
                    Text("Tag")
                    List {
                        ForEach(self.tagSecond.sorted(by: { $0.value > $1.value }), id: \.key) {key, value in
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
        let sess = self.db.document(self.uid).collection("sessions")
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
                                    self.vehiclePercent[name] = self.vehicleAccuracy[name]! / self.vehicleCount[name]!
                                    self.vehicleSecond[name] = self.vehicleTime[name]! / self.vehicleCount[name]!
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
                                            self.tagPercent[label] = self.tagAccuracy[label]! / self.tagCount[label]!
                                            self.tagSecond[label] = self.tagTime[label]! / self.tagCount[label]!
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
        StatDetail(uid: "")
    }
}
