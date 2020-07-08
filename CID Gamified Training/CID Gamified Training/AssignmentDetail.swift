//
//  AssignmentDetail.swift
//  CID Gamified Training
//
//  Created by Alex on 7/6/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct AssignmentDetail: View {
    
    var assignment: Assignment
    
    /** Show alert. */
    @State var alert = false
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    @State var doc: DocumentReference?
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    var body: some View {
        VStack {
            Text(self.assignment.name)
            Text("Directions: Click a vehicle to move it.  The order is Library -> Friendly -> Enemy -> Library")
            HStack {
                VStack {
                    Text("Library")
                        .font(.title)
                        .fontWeight(.heavy)
                    List {
                        ForEach(self.assignment.library.sorted(), id: \.id) {card in
                            CardView(folder: card.name, back: Color.gray)
                        }
                    }
                }
                VStack {
                    Text("Friendly")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.assignment.friendly.sorted(), id: \.id) {card in
                            CardView(folder: card.name, back: Color.blue)
                        }
                    }
                    Text("Enemy")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.assignment.enemy.sorted(), id: \.id) {card in
                            CardView(folder: card.name, back: Color.red)
                        }
                    }
                }
            }
            
            if self.user.userType == "instructor" {
                Button(action: {
                    if let docu = self.doc {
                        docu.collection("assignments").document(self.assignment.name).delete()
                        self.doc = nil
                    }
                }) {
                    Text("Delete Assigment")
                }
            } else {
                Button(action: {
                    Model.unselectedFolder = self.assignment.library
                    Model.friendlyFolder = self.assignment.friendly
                    Model.enemyFolder = self.assignment.enemy
                    Model.friendly = Model.settingLoad(name: "friendly")
                    Model.foe = Model.settingLoad(name: "enemy")
                    self.db.document(self.user.uid).setData(["friendly":[], "enemy":[]], merge: true)
                    for card in self.assignment.friendly {
                        self.db.document(self.user.uid).setData(["friendly": FieldValue.arrayUnion([card.name])], merge: true)
                    }
                    for card in self.assignment.enemy {
                        self.db.document(self.user.uid).setData(["enemy": FieldValue.arrayUnion([card.name])], merge: true)
                    }
                }) {
                    Text("Save")
                }
            }
        }
    }
}

struct AssignmentDetail_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetail(assignment: Assignment(name: "", library: [], friendly: [], enemy: []), doc: nil).environmentObject(GlobalUser())
    }
}
