//
//  Instructor.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/22/20.
//  Copyright © 2020 X-Force. All rights reserved.
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
    @State var classes: [String:DocumentReference] = [:]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Text("\(name)'s Instructor Portal")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    Spacer()
                }
                Text("  Classes:")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                List {
                    ForEach(self.classes.sorted(by: { $0.0 < $1.0 }), id: \.key) {key, value in
                        NavigationLink(destination: Students(doc: value, name: key)){
                            Text(key).foregroundColor(Color.white)
                        }
                    } .listRowBackground(Color(red: 0.2, green: 0.2, blue: 0.2))
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.logout()
                    }) {
                        Text("Sign out")
                        .foregroundColor(Color.white)
                        .padding(15)
                        .background(Color(red: 0, green: 0.2, blue: 0))
                        .cornerRadius(25)
                    }
                    Spacer()
                    NavigationLink(destination: Focus()) {
                        Text(self.user.regular)
                        .foregroundColor(Color.white)
                        .padding(15)
                        .background(Color(red: 0, green: 0.4, blue: 0))
                        .cornerRadius(25)
                    }
                    Spacer()
                    NavigationLink(destination: EditClasses(listClass: self.$classes)) {
                        Text("Edit Classes")
                        .foregroundColor(Color.white)
                        .padding(15)
                        .background(Color(red: 0, green: 0.6, blue: 0))
                        .cornerRadius(25)
                    }
                    Spacer()
                }
            } .background(Color.lightBlack.edgesIgnoringSafeArea(.all))
                .onAppear{
                    UITableView.appearance().backgroundColor = .clear
                    self.setHeader(doc: self.db.document(self.user.uid))
                    self.getClasses(db: self.db.document(self.user.uid).collection("classes"))
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
    
    /** Gets list of sessions for this user from firebase.
     Parameters:
        db - CollectionReference to the classes collection in Firebase. */
    func getClasses(db: CollectionReference) {
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                for document in query!.documents {
                    let docu = db.document(document.documentID)
                    self.classes[document.documentID] = docu
                }
            }
        }
    }
    
    /** Obtain name and email from firebase.
     Parameters:
        doc - DocumentReference to the user document. */
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
