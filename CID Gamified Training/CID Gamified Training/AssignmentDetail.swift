//
//  AssignmentDetail.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 7/6/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import SwiftUI
import Firebase

/** View that displays detailed information about a specific assignment.
 Displays enemy and friendly vehicles as well as required accuracy rates and time for assignment. */
struct AssignmentDetail: View {
    
    /** Assignment to be displayed in detail. */
    var assignment: Assignment
    
    /** Show alert. */
    @State var alert = false
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Document Reference of class in Firebase. */
    @State var doc: DocumentReference?
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Alert title. */
    @State var alertTitle = "Success"
    
    /** Alert message. */
    @State var error = ""
    
    /** Mapping from assignment name to assignment. */
    @Binding var assignments: [String : Assignment]
    
    var body: some View {
        VStack(spacing: 20) {
            Text(self.assignment.name)
            .font(.title)
            .fontWeight(.black)
            .foregroundColor(Color.white)
            Text("Requirements")
            .font(.title)
            .fontWeight(.semibold)
                .foregroundColor(Color.white)
            HStack {
                StatBox(img_name: "acc1", description: "Friendly Accuracy", item: Text("\(self.assignment.friendlyAccuracy, specifier: "%.1f")%")).foregroundColor(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.white, lineWidth: 2)
                )
                StatBox(img_name: "acc2", description: "Enemy Accuracy", item: Text("\(self.assignment.enemyAccuracy, specifier: "%.1f")%")).foregroundColor(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.white, lineWidth: 2)
                )
            }
            StatBox(img_name: "time", description: "Time Allotted", item: Text("\(self.assignment.time, specifier: "%.1f") s")).foregroundColor(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(Color.white, lineWidth: 2)
            )
            HStack {
                VStack {
                    Text("Library")
                        .font(.title)
                        .fontWeight(.heavy)
                    List {
                        ForEach(self.assignment.library.sorted(), id: \.id) {card in
                            CardView(folder: card.name, back: Color.gray)
                        }.listRowBackground(Color.lightBlack)
                    }
                }
                VStack {
                    Text("Friendly")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.assignment.friendly.sorted(), id: \.id) {card in
                            CardView(folder: card.name, back: Color.blue)
                        }.listRowBackground(Color.lightBlack)
                    }
                    Text("Enemy")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.assignment.enemy.sorted(), id: \.id) {card in
                            CardView(folder: card.name, back: Color.red)
                        }.listRowBackground(Color.lightBlack)
                    }
                }
            }
            if self.user.userType == "instructor" && self.doc != nil{
                HStack{
                    Spacer()
                    Button(action: {
                        if let docu = self.doc {
                            self.assignments[self.assignment.name] = nil
                            docu.collection("assignments").document(self.assignment.name).delete()
                            self.doc = nil
                            self.alertTitle = "Success"
                            self.error = "Assigment successfully deleted."
                            self.alert = true
                        } else {
                            self.alertTitle = "Error"
                            self.error = "This assignment does not exist."
                            self.alert = true
                        }
                    }) {
                        Text("Delete Assigment")
                        .padding(15)
                        .background(Color(red: 0.5, green: 0, blue: 0))
                        .foregroundColor(Color.white)
                        .cornerRadius(25)
                    }
                    Spacer()
                    NavigationLink(destination: Students(doc: self.doc, name: "Assignment \(self.assignment.name)", assignment: self.doc!.collection("assignments").document(self.assignment.name))) {
                        Text("Progress")
                        .padding(15)
                        .background(Color(red: 0.6, green: 0.6, blue: 0.6))
                        .foregroundColor(Color.white)
                        .cornerRadius(25)
                        }
                    Spacer()
                }
            } else if self.user.userType == "student"{
                Button(action: {
                    Model.unselectedFolder = self.assignment.library
                    Model.friendlyFolder = self.assignment.friendly
                    Model.enemyFolder = self.assignment.enemy
                    Model.friendly = Model.settingLoad(name: "friendly")
                    Model.foe = Model.settingLoad(name: "enemy")
                    self.db.document(self.user.uid).setData(["friendly":[], "enemy":[]], merge: true)
                    for card in self.assignment.friendly {
                        self.db.document(self.user.uid).setData(["friendly": FieldValue.arrayUnion([card.name])], merge: true)
                    }
                    for card in self.assignment.enemy {
                        self.db.document(self.user.uid).setData(["enemy": FieldValue.arrayUnion([card.name])], merge: true)
                    }
                    self.alertTitle = "Success"
                    self.error = "Settings successfully saved."
                    self.alert = true
                }) {
                    Text("Save")
                    .padding(15)
                    .background(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .foregroundColor(Color.white)
                    .cornerRadius(25)
                }
            }
        }.background(Color.lightBlack.edgesIgnoringSafeArea(.all))
        .onAppear{
            UITableView.appearance().backgroundColor = .clear
        }
        .alert(isPresented: self.$alert) {
            Alert(title: Text("\(self.alertTitle)"), message: Text(self.error), dismissButton: .default(Text("Dismiss"), action: {
            self.alert = false
        }))}
    }
}

struct AssignmentDetail_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetail(assignment: Assignment(name: "", library: [], friendly: [], enemy: [], friendlyAccuracy: 100, enemyAccuracy: 100, time: 60), doc: nil, assignments: Binding.constant([:])).environmentObject(GlobalUser())
    }
}
