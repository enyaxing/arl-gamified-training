//
//  Profile.swift
//  CID Gamified Training
//
//  Created by Alex on 6/22/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct Profile: View {
    
    /** Reference to global user variable. */
    //@EnvironmentObject var user: GlobalUser
    
    var uid: String
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    @State var prevSessions: [String] = []
    @State var answers: [Answer] = []
    @State var name = "test"
    @State var email = "test"
    
    var body: some View {
        VStack {
            Text(name)
            Text(email)
            Text("Previous Sessions:")
            List {
                ForEach(self.prevSessions, id: \.self) {sess in
                    NavigationLink(destination: Summary(answers: self.answers, sess: sess, countdown:Binding.constant(false), uid: self.uid)){
                        Text(sess)
                    }
                }
            }
        }.onAppear{
            self.setHeader(doc: self.db.document(self.uid))
            self.getSessions(db: self.db.document(self.uid).collection("sessions"))
        }
    }

    func getSessions(db: CollectionReference) {
        var ret: [String] = []
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                for document in query!.documents {
                    ret.append(document.documentID)
                }
                self.prevSessions = ret
            }
        }
    }
    
    /** Obtain field value from firebase user. */
    func setHeader(doc: DocumentReference){
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("name") != nil {
                    self.name = document.get("name") as! String
                }
                if document.get("user") != nil {
                    self.email = document.get("user") as! String
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(uid: "").environmentObject(GlobalUser())
    }
}
