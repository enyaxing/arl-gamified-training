//
//  StudentCard.swift
//  CID Gamified Training
//
//  Created by Alex on 7/14/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct StudentCard: View {
    
    var name: String
    var id: String
    var doc: DocumentReference?
    @State var complete = false
    
    var body: some View {
        Group {
            if self.complete {
                HStack {
                    Text(self.name)
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("COMPLETE")
                        .foregroundColor(Color.white)
                }
            } else {
                HStack {
                    Text(self.name)
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("INCOMPLETE")
                        .foregroundColor(Color.red)
                }
            }
        } .onAppear{
            self.checkStudent(doc: self.doc!)
        }
    }
    
    func checkStudent(doc: DocumentReference) {
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("completed") != nil {
                    let completion = document.get("completed") as! [String]
                    for id in completion {
                        if id == self.id {
                            self.complete = true
                            break
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

struct StudentCard_Previews: PreviewProvider {
    static var previews: some View {
        StudentCard(name: "test", id: "test")
    }
}
