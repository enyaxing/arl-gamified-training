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
            Button(action: {
                if let docu = self.doc {
                    docu.collection("assignments").document(self.assignment.name).delete()
                    self.doc = nil
                }
                
            }) {
                Text("Delete Assigment")
            }
        }
    }
}

struct AssignmentDetail_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetail(assignment: Assignment(name: "", library: [], friendly: [], enemy: []), doc: nil)
    }
}
