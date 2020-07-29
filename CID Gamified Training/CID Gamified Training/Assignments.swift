//
//  Assignments.swift
//  CID Gamified Training
//
//  Created by Alex on 7/6/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct Assignments: View {
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    @State var assignments: [String : Assignment] = [:]
    
    var classes: DocumentReference?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Text("Assignments:")
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(Color.white)
                Spacer()
            }
            List {
                ForEach(self.assignments.sorted(by: { $0.0 < $1.0 }), id: \.key) {key, value in
                    NavigationLink(destination: AssignmentDetail(assignment: value, doc: self.classes, assignments: self.$assignments)){
                        Text(key).foregroundColor(Color.white)
                    }
                }.listRowBackground(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
            if self.user.userType == "instructor" {
                HStack{
                    Spacer()
                    NavigationLink(destination: Setting(classes: self.classes)){
                        Text("Create Assignment")
                        .foregroundColor(Color.white)
                        .padding(15)
                        .background(Color(red: 0, green: 0.6, blue: 0))
                        .cornerRadius(25)
                    }
                    Spacer()
                }
            }
        }.background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear{
            UITableView.appearance().backgroundColor = .clear
            self.getassignments(db: self.classes!.collection("assignments"))
        }
    }
    
    /** Gets list of sessions for this user from firebase. */
    func getassignments(db: CollectionReference) {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/CID Images"
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                for document in query!.documents {
                    let friendly: [Card] = strCards(arr: document.get("friendly") as! [String])
                    let enemy: [Card] = strCards(arr: document.get("enemy") as! [String])
                    let friendlyAccuracy = document.get("friendlyAccuracy") as! Double
                    let enemyAccuracy = document.get("enemyAccuracy") as! Double
                    let time = document.get("time") as! Double
                    var library: [Card] = []
                    do {
                        let items = try fm.contentsOfDirectory(atPath: path)
                        for item in items {
                            if check(name: item, arr: friendly) && check(name: item, arr: enemy) {
                                library.append(Card(name: "\(item)"))
                            }
                        }
                    } catch {
                        print("error")
                    }
                    self.assignments[document.documentID] = Assignment(name: document.documentID, library: library, friendly: friendly, enemy: enemy, friendlyAccuracy: friendlyAccuracy, enemyAccuracy: enemyAccuracy, time: time)
                }
            }
        }
    }
}

func strCards(arr: [String]) -> [Card] {
    var ret: [Card] = []
    for str in arr {
        ret.append(Card(name: str))
    }
    return ret
}

struct Assignments_Previews: PreviewProvider {
    static var previews: some View {
        Assignments(classes: nil).environmentObject(GlobalUser())
    }
}
