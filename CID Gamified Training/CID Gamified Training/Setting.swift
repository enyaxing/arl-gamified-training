//
//  Setting.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/19/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import SwiftUI
import Firebase

/** Settings page that lets user select enemy and friendly vehicles. */
struct Setting: View {
    
    /** Library of unselected folders. */
    @State var library: [Card] = Model.unselectedFolder
    
    /** List of friendly folders. */
    @State var friendly: [Card] = Model.friendlyFolder
    
    /** List of enemy folders. */
    @State var enemy: [Card] = Model.enemyFolder
    
    /** Show alert. */
    @State var alert = false
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Assignment name. */
    @State var name = ""
    
    /** Required friendly accuracy percentage. */
    @State var friendlyAccuracy = 100
    
    /** Required enemy accruacy percentage. */
    @State var enemyAccuracy = 100
    
    /** Required time of assignment completion. */
    @State var time = 60
    
    /** Document reference to class in Firebase. */
    @State var classes: DocumentReference? = nil
    
    /** Title of alert. */
    @State var alertTitle = "Error"
    
    /** Alert message. */
    @State var alertMessage = "Cannot have empty friendly or enemy list. Please add another vehicle before removing this vehicle."
    
    var body: some View {
        VStack {
            if self.user.userType == "instructor" {
                Text("Create Assignment")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.white)
                TextField("Assignment Name", text: $name)
                NavigationLink(destination: AdvancedSetting(friendlyAccuracy: self.$friendlyAccuracy, enemyAccuracy: self.$enemyAccuracy, time: self.$time)) {
                    Text("Advanced Settings")
                }
            } else {
                Text("Settings")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.white)
            }
            Rectangle()
            .frame(height: 1.0, alignment: .bottom)
            .foregroundColor(Color.white)
            .offset(y: -15)
            Text("Directions: Click a vehicle to move it.  The order is Library → Friendly → Enemy → Library.")
             .foregroundColor(Color.white)
            Spacer()
            HStack {
                VStack {
                    Text("Library")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    List {
                        ForEach(self.library, id: \.id) {card in
                            CardView(folder: card.name, back: Color.gray)
                                .onTapGesture {
                                    let index = self.library.firstIndex(of: card) ?? 0
                                    self.friendly.append(card)
                                    self.friendly = self.friendly.sorted()
                                    self.library.remove(at: index)
                            }
                        }.listRowBackground(Color.lightBlack)
                    }
                }
                VStack {
                    Text("Friendly")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    List {
                        ForEach(self.friendly, id: \.id) {card in
                            CardView(folder: card.name, back: Color.darkBlue)
                                .onTapGesture {
                                    let index = self.friendly.firstIndex(of: card) ?? 0
                                    self.enemy.append(card)
                                    self.enemy = self.enemy.sorted()
                                    self.friendly.remove(at: index)
                            }
                        }.listRowBackground(Color.lightBlack)
                    }
                    Text("Enemy")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    List {
                        ForEach(self.enemy, id: \.id) {card in
                            CardView(folder: card.name, back: Color.enemyRed)
                                .onTapGesture {
                                    let index = self.enemy.firstIndex(of: card) ?? 0
                                    self.library.append(card)
                                    self.library = self.library.sorted()
                                    self.enemy.remove(at: index)
                            }
                        }.listRowBackground(Color.lightBlack)
                    }
                }
            }
            HStack {
                Spacer()
                Button(action: {
                    Model.friendlyFolder = [Card(name: "BRDM-2 Sagger")]
                    Model.enemyFolder = [Card(name: "BRDM-2 Spandrel")]
                    Model.unselectedFolder = dirLoad()
                    self.library = Model.unselectedFolder.sorted()
                    self.friendly = Model.friendlyFolder.sorted()
                    self.enemy = Model.enemyFolder.sorted()
                    self.name = ""
                    self.friendlyAccuracy = 100
                    self.enemyAccuracy = 100
                    self.time = 60
                }) {
                    Text("Reset")
                     .foregroundColor(Color.white)
                    .padding(15)
                    .background(Color(red: 0, green: 0.2, blue: 0))
                    .cornerRadius(25)
                }
                Spacer()
                Button(action: {
                    self.save()
                }) {
                    Text("Save")
                    .foregroundColor(Color.white)
                    .padding(15)
                    .background(Color(red: 0, green: 0.4, blue: 0))
                    .cornerRadius(25)
                }
                Spacer()
                if self.user.userType != "instructor" && self.classes != nil{
                    NavigationLink(destination: Assignments(classes: self.classes!)) {
                        Text("Assignments")
                        .foregroundColor(Color.white)
                        .padding(15)
                        .background(Color(red: 0, green: 0.6, blue: 0))
                        .cornerRadius(25)
                    }
                    Spacer()
                }
                if self.user.userType == "student" {
                    Button(action: {
                        self.random()
                    }) {
                        Text("Random")
                        .foregroundColor(Color.white)
                        .padding(15)
                        .background(Color(red: 0, green: 0.8, blue: 0))
                        .cornerRadius(25)
                    }
                    Spacer()
                }
            }
        }
        .alert(isPresented: $alert) {
            Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("Dismiss"), action: {
                self.alert = false
            }))
        }.onAppear {
            UITableView.appearance().backgroundColor = .clear
            self.library = Model.unselectedFolder.sorted()
            self.friendly = Model.friendlyFolder.sorted()
            self.enemy = Model.enemyFolder.sorted()
            self.getClass()
        }.background(Color.lightBlack.edgesIgnoringSafeArea(.all))
    }
    
    /** If student, saves the current settings to be used in training games.
        if instructor, saves the current settings as an assignment. */
    func save() {
        if self.friendly.count == 0 || self.enemy.count == 0 {
            self.alertTitle = "Error"
            self.alertMessage = "Cannot have empty friendly or enemy list."
            self.alert = true
        } else {
            if self.user.userType == "instructor" {
                let coll = self.classes!.collection("assignments")
                coll.document(self.name).setData(["friendly":[], "enemy":[], "friendlyAccuracy": self.friendlyAccuracy, "enemyAccuracy": self.enemyAccuracy, "time": self.time])
                for card in self.friendly {
                    coll.document(self.name).setData(["friendly": FieldValue.arrayUnion([card.name])], merge: true)
                }
                for card in self.enemy {
                    coll.document(self.name).setData(["enemy": FieldValue.arrayUnion([card.name])], merge: true)
                }
            } else {
                Model.unselectedFolder = self.library
                Model.friendlyFolder = self.friendly
                Model.enemyFolder = self.enemy
                Model.friendly = Model.settingLoad(name: "friendly")
                Model.foe = Model.settingLoad(name: "enemy")
                self.db.document(self.user.uid).setData(["friendly":[], "enemy":[]], merge: true)
                for card in self.friendly {
                    self.db.document(self.user.uid).setData(["friendly": FieldValue.arrayUnion([card.name])], merge: true)
                }
                for card in self.enemy {
                    self.db.document(self.user.uid).setData(["enemy": FieldValue.arrayUnion([card.name])], merge: true)
                }
            }
            self.alertTitle = "Success"
            self.alertMessage = "Settings successfully saevd."
            self.alert = true
        }
    }
    
    /** Gets the class of the student. */
    func getClass() {
        let doc = self.db.document(self.user.uid)
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("class") != nil {
                    self.classes = document.get("class") as? DocumentReference
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    /** Generates a random assignment.
        Selects one enemy and one friendly vehicle uniformly at random. */
    func random() {
        self.library += self.friendly
        self.library += self.enemy
        self.friendly.removeAll()
        self.enemy.removeAll()
        var index = Int.random(in: 0..<library.count)
        self.friendly.append(self.library[index])
        self.library.remove(at: index)
        index = Int.random(in: 0..<library.count)
        self.enemy.append(self.library[index])
        self.library.remove(at: index)
        self.library.sort()
        self.enemy.sort()
        self.friendly.sort()
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting().environmentObject(GlobalUser())
    }
}
