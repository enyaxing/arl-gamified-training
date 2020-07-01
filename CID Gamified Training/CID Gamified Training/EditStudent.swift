//
//  EditStudent.swift
//  CID Gamified Training
//
//  Created by Alex on 6/30/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct EditStudent: View {
    @State var email = ""
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    var body: some View {
        VStack {
            TextField("Student's Email", text: $email)
            HStack {
                Spacer()
                Button(action: {
                    self.add(email: self.email)
                }) {
                    Text("Add Student")
                }
                Spacer()
                Button(action: {
                    self.remove(email: self.email)
                }) {
                    Text("Remove Student")
                }
                Spacer()
            }
        }
    }
    
    func add(email: String) {
        let instructor = db.document(self.user.uid)
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                for document in query!.documents {
                    if email.lowercased() == (document.get("user") as! String).lowercased() {
                        instructor.updateData([
                            "studentname": FieldValue.arrayUnion([document.get("name") as! String]),
                            "studentuid": FieldValue.arrayUnion([document.get("uid") as! String])
                        ])
                        break
                    }
                }
            }
        }
    }
    
    func remove(email: String) {
        let instructor = db.document(self.user.uid)
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                for document in query!.documents {
                    if email.lowercased() == (document.get("user") as! String).lowercased() {
                        instructor.updateData([
                            "studentname": FieldValue.arrayRemove([document.get("name") as! String]),
                            "studentuid": FieldValue.arrayRemove([document.get("uid") as! String])
                        ])
                        break
                    }
                }
            }
        }
    }
}



struct EditStudent_Previews: PreviewProvider {
    static var previews: some View {
        EditStudent().environmentObject(GlobalUser())
    }
}
