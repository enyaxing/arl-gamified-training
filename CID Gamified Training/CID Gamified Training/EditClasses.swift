//
//  EditClasses.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 7/7/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import SwiftUI
import Firebase

/** View that lets you add and remove classes. */
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
    
    /** Mapping from class name to class documentReference in Firebase. */
    @Binding var listClass: [String:DocumentReference]
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Class Name", text: $classes)
                .inputStyle()
            HStack {
                Spacer()
                Button(action: {
                    self.add(classes: self.classes)
                }) {
                    Text("Add Class")
                    .foregroundColor(Color.white)
                    .padding(15)
                    .background(Color(red: 0, green: 0.2, blue: 0))
                    .cornerRadius(25)
                }
                Spacer()
                Button(action: {
                    self.remove(classes: self.classes)
                }) {
                    Text("Remove Class")
                    .foregroundColor(Color.white)
                    .padding(15)
                    .background(Color(red: 0, green: 0.6, blue: 0))
                    .cornerRadius(25)
                }
                Spacer()
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lightBlack.edgesIgnoringSafeArea(.all))
            .alert(isPresented: self.$alert) {
            Alert(title: Text("\(self.alertTitle)"), message: Text(self.error), dismissButton: .default(Text("Dismiss"), action: {
            self.alert = false
        }))}
    }
    
    /** Add class to instructor profile.
     Parameters:
        classes - class name to create. */
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
    
    /** Remove a class from instructor profile.
     Parameters:
        classes - class name to remove. */
    func remove(classes: String) {
        let db = self.db.document(self.user.uid).collection("classes")
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                self.found = false
                for document in query!.documents {
                    if document.documentID == classes{
                        let students = document.get("students") as! [String:String]
                        for (stud, _) in students {
                            self.db.document(stud).updateData(["class": FieldValue.delete()])
                        }
                        self.listClass[document.documentID] = nil
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
        EditClasses(listClass: Binding.constant([:])).environmentObject(GlobalUser())
    }
}
