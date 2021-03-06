//
//  StatDetail.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 7/14/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import SwiftUI
import Firebase

/** View shows detailed statistics on vehicles and tags.
 Displays accuracy percentage and average response time. */
struct StatDetail: View {
    
    /** List of previous sessions identified by their id in Firebase. */
    @State var prevSessions: [String] = []
    
    /** Mapping from vehicle name to total response time. */
    @State var vehicleTime: [String: Double] = [:]
    
    /** Mapping from tag to total response time. */
    @State var tagTime: [String: Double] = [:]
    
    /** Mapping from vehicle name to total number correct. */
    @State var vehicleAccuracy: [String: Double] = [:]
    
    /** Mapping from tag to total number correct. */
    @State var tagAccuracy: [String: Double] = [:]
    
    /** Mapping from vehicle name to total number of questions. */
    @State var vehicleCount: [String: Double] = [:]
    
    /** Mapping from tag to total number of questions. */
    @State var tagCount: [String: Double] = [:]
    
    /** Mapping from vehicle name to percentage correct. */
    @State var vehiclePercent: [String: Double] = [:]
    
    /** Mapping from tag to percentage correct. */
    @State var tagPercent: [String: Double] = [:]
    
    /** Mapping from vehicle name to average response time in seconds. */
    @State var vehicleSecond: [String: Double] = [:]
    
    /** Mapping from tag to average response time in seconds. */
    @State var tagSecond: [String: Double] = [:]
    
    /** Selected tab.
     0 == vehicles, 1 == tag. */
    @State var selectedTab = 0
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** UID of student. */
    var uid: String
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Text("Stat Details")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    Spacer()
                }
                Text("Vehicle Accuracy")
                    .font(.custom("Helvetica-Bold", size: 24))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                List {
                    ForEach(self.vehiclePercent.sorted(by: { $0.value > $1.value }), id: \.key) {key, value in
                        StatView(name: key, num: value, type: 0)
                    }.listRowBackground(Color.lightBlack)
                }
                Text("Vehicle Average Response Time")
                .font(.custom("Helvetica-Bold", size: 24))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                List {
                    ForEach(self.vehicleSecond.sorted(by: { $0.value > $1.value}), id: \.key) {key, value in
                        StatView(name: key, num: value, type: 1)
                    }.listRowBackground(Color.lightBlack)
                }
            } .tabItem {
                Image(systemName: "car.fill")
                Text("Vehicle")
            }.tag(0)
            .background(Color.lightBlack.edgesIgnoringSafeArea(.all))
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Text("Stat Details")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    Spacer()
                }
                Text("Tag Accuracy")
                .font(.custom("Helvetica-Bold", size: 24))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                List {
                    ForEach(self.tagPercent.sorted(by: { $0.value > $1.value }), id: \.key) {key, value in
                        StatView(name: key, num: value, type: 0)
                    }.listRowBackground(Color.lightBlack)
                }
                Text("Tag Average Response Time")
                .font(.custom("Helvetica-Bold", size: 24))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                List {
                    ForEach(self.tagSecond.sorted(by: { $0.value > $1.value }), id: \.key) {key, value in
                        StatView(name: key, num: value, type: 1)
                    }.listRowBackground(Color.lightBlack)
                }
            }.tabItem {
                Image(systemName: "tag")
                Text("Tag")
            }.tag(1)
            .background(Color.lightBlack.edgesIgnoringSafeArea(.all))
        }
        .onAppear{
            UITableView.appearance().backgroundColor = .clear
            UITabBar.appearance().backgroundColor = UIColor.lightGray
            self.getStats(sessions: self.prevSessions)
        }
    }
    
    /** Get stats by counting number of responses, number of correct responses,
     and summing response time for each vehicle and tag.
     Parameters:
        sessions - List of session ids to loop through. */
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
                                        break
                                    }
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
