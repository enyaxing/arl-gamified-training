//
//  Students.swift
//  CID Gamified Training
//
//  Created by Alex on 7/7/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct Students: View {
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Dictionary of student IDs to student names. */
    @State var students: [String:String] = [:]
    
    var doc: DocumentReference?
    
    var name: String
    
    var assignment: DocumentReference?
    
    var body: some View {
        VStack{
            Text(self.name)
            Text("Students:")
            List {
                ForEach(self.students.sorted(by: { $0.value < $1.value }), id: \.key) {key, value in
                    Group{
                        if self.assignment ==  nil {
                            NavigationLink(destination: Profile(uid: key)){
                                Text(value)
                            }
                        } else {
                            StudentCard(name: value, id: key, doc: self.assignment)
                        }
                    }
                }
            }
            if self.assignment == nil {
                HStack {
                    Spacer()
                    NavigationLink(destination: EditStudent(classes: self.doc)) {
                        Text("Edit Students")
                        .padding(10)
                        .background(Color.gray)
                        .cornerRadius(10)
                    }
                    Spacer()
                    NavigationLink(destination: Assignments(classes: self.doc)) {
                        Text("Assignments")
                        .padding(10)
                        .background(Color.gray)
                        .cornerRadius(10)
                    }
                    Spacer()
                }
            }
        } .onAppear{
            self.getStudents(doc: self.doc!)
        }
    }
    
    /** Obtain students from firebase*/
    func getStudents(doc: DocumentReference) {
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("students") != nil {
                    self.students = document.get("students") as! [String:String]
                } else {
                    doc.setData(["students": [:]], merge: true)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

struct Students_Previews: PreviewProvider {
    static var previews: some View {
        Students(doc: nil, name: "Class Name").environmentObject(GlobalUser())
    }
}
