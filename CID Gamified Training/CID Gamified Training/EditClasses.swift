//
//  EditClasses.swift
//  CID Gamified Training
//
//  Created by Alex on 7/7/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct EditClasses: View {
    
    /** Email in the text input field. */
    @State var classes = ""
    
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
            TextField("Class Name", text: $classes)
            HStack {
                Spacer()
                Button(action: {
                    self.add(classes: self.classes)
                }) {
                    Text("Add Class")
                }
                Spacer()
                Button(action: {
                    self.remove(classes: self.classes)
                }) {
                    Text("Remove Class")
                }
                Spacer()
            }
        }.alert(isPresented: self.$alert) {
            Alert(title: Text("\(self.alertTitle)"), message: Text(self.error), dismissButton: .default(Text("Dismiss"), action: {
            self.alert = false
        }))}
    }
    
    func add(classes: String) {
        let db = self.db.document(self.user.uid).collection("classes")
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                self.found = false
                for document in query!.documents {
                    if document.documentID == classes{
                        self.found = true
                        self.alertTitle = "Error"
                        self.error = "You already have a class with that name."
                        self.alert = true
                        break
                    }
                }
                if !self.found {
                    db.document(classes).setData(["students": [:]])
                    self.alertTitle = "Success"
                    self.error = "Class successfully added."
                    self.alert = true
                }
            }
        }
    }
    
    func remove(classes: String) {
        let db = self.db.document(self.user.uid).collection("classes")
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                self.found = false
                for document in query!.documents {
                    if document.documentID == classes{
                        db.document(document.documentID).delete()
                        self.found = true
                        self.alertTitle = "Success"
                        self.error = "Class successfully removed."
                        self.alert = true
                        break
                    }
                }
                if !self.found {
                    self.alertTitle = "Error"
                    self.error = "No such class found."
                    self.alert = true
                }
            }
        }
    }
}

struct EditClasses_Previews: PreviewProvider {
    static var previews: some View {
        EditClasses()
    }
}
