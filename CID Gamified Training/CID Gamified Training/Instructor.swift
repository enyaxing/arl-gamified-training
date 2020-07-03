//
//  Instructor.swift
//  CID Gamified Training
//
//  Created by Alex on 6/22/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

/** Instructor view for signed in instructor. */
struct Instructor: View {
    
    /** Save defaults locally (ie. who is signed in). */
    let defaults = UserDefaults.standard
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Error message for alerts. */
    @State var error = ""
    
    /** Is logout invalid. */
    @State var invalid = false
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Instructor name. */
    @State var name = "test"
    
    /** Instructor email. */
    @State var email = "test"
    
    /** Dictionary of student IDs to student names. */
    @State var students: [String:String] = [:]
    
    var body: some View {
        NavigationView{
        VStack {
            Text(name)
            Text(email)
            Text("Students:")
            List {
                ForEach(self.students.sorted(by: { $0.value < $1.value }), id: \.key) {key, value in
                    NavigationLink(destination: Profile(uid: key)){
                        Text(value)
                    }
                }
            }
            HStack {
                Spacer()
                Button(action: {
                    self.logout()
                }) {
                    Text("Sign out")
                }
                Spacer()
                NavigationLink(destination: Focus()) {
                    Text(self.user.regular)
                }
                Spacer()
                NavigationLink(destination: EditStudent()) {
                    Text("Edit Students")
                }
                Spacer()
            }
        }.onAppear{
            self.setHeader(doc: self.db.document(self.user.uid))
            self.getStudents(doc: self.db.document(self.user.uid))
        }
    }
    }
    
    /** Logout function. */
    func logout() {
        do {
            try Auth.auth().signOut()
            self.user.uid = ""
            self.user.userType = "student"
            defaults.set("", forKey: "uid")
            defaults.set("student", forKey: "userType")
        } catch let error as NSError {
            self.error = error.localizedDescription
            self.invalid = true
        }
    }
    
    /** Obtain students from firebase*/
    func getStudents(doc: DocumentReference) {
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("students") != nil {
                    self.students = document.get("students") as! [String:String]
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    /** Obtain name and email from firebase. */
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

struct Instructor_Previews: PreviewProvider {
    static var previews: some View {
        Instructor().environmentObject(GlobalUser())
    }
}
