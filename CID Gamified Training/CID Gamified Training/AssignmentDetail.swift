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
                        ForEach(self.assignment.library, id: \.id) {card in
                            CardView(folder: card.name, back: Color.gray)
                        }
                    }
                }
                VStack {
                    Text("Friendly")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.assignment.friendly, id: \.id) {card in
                            CardView(folder: card.name, back: Color.blue)
                        }
                    }
                    Text("Enemy")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.assignment.enemy, id: \.id) {card in
                            CardView(folder: card.name, back: Color.red)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text("Cannot have empty friendly or enemy list. Please add another vehicle before removing this vehicle."), dismissButton: .default(Text("Dismiss"), action: {
                self.alert = false
            }))
        }
    }
}

struct AssignmentDetail_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetail(assignment: Assignment(name: "", library: [], friendly: [], enemy: []))
    }
}
