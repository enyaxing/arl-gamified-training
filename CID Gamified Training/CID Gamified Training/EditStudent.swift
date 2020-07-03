//
//  EditStudent.swift
//  CID Gamified Training
//
//  Created by Alex on 6/30/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

/** View that lets instructor add and remove students by email. */
struct EditStudent: View {
    
    /** Email in the text input field. */
    @State var email = ""
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Show alert. */
    @State var alert = false
    
    /** Alert title. */
    @State var alertTitle = "Success"
    
    /** Error message for alert. */
    @State var error = ""
    
    /** Has the user been found.*/
    @State var found = false
    
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
        }.alert(isPresented: self.$alert) {
            Alert(title: Text("\(self.alertTitle)"), message: Text(self.error), dismissButton: .default(Text("Dismiss"), action: {
            self.alert = false
        }))}
    }
    
    /** Add a student to the list of students for this instructor. */
    func add(email: String) {
        let instructor = db.document(self.user.uid)
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                self.found = false
                for document in query!.documents {
                    if email.lowercased() == (document.get("user") as! String).lowercased() {
                        self.found = true
                        instructor.getDocument { (docu, error) in
                            if let docu = docu, docu.exists {
                                if docu.get("students") != nil {
                                    let students = docu.get("students") as! [String: String]
                                    if students.index(forKey: document.get("uid") as! String) == nil {
                                        instructor.updateData([
                                            "students.\(document.get("uid") as! String)": document.get("name") as! String,
                                        ])
                                        self.error = "Adding student successful."
                                        self.alertTitle = "Success"
                                    } else {
                                        self.error = "You already have a student with that email."
                                        self.alertTitle = "Error"
                                    }
                                    self.alert = true
                                }
                            } else {
                                print("Document does not exist")
                            }
                        }
                        break
                    }
                }
                if !self.found {
                    self.error = "No user with that email found."
                    self.alertTitle = "Error"
                    self.alert = true
                }
            }
        }
    }
    
    /** Remove student from the list of students for this instructor. */
    func remove(email: String) {
        let instructor = db.document(self.user.uid)
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                self.found = false
                for document in query!.documents {
                    if email.lowercased() == (document.get("user") as! String).lowercased() {
                        self.found = true
                        instructor.getDocument { (docu, error) in
                            if let docu = docu, docu.exists {
                                if docu.get("students") != nil {
                                    let students = docu.get("students") as! [String: String]
                                    if students.index(forKey: document.get("uid") as! String) == nil {
                                        self.error = "You do not have a student with that email."
                                        self.alertTitle = "Error"
                                    } else {
                                        instructor.updateData([
                                            "students.\(document.get("uid") as! String)": FieldValue.delete()
                                        ])
                                        self.error = "Removing student successful."
                                        self.alertTitle = "Success"
                                    }
                                    self.alert = true
                                }
                            } else {
                                print("Document does not exist")
                            }
                        }
                        break
                    }
                }
                if !self.found {
                    self.error = "No user with that email found."
                    self.alertTitle = "Error"
                    self.alert = true
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
