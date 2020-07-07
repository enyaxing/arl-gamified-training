//
//  Setting.swift
//  CID Gamified Training
//
//  Created by Alex on 6/19/20.
//  Copyright © 2020 Alex. All rights reserved.
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
    
    @State var name = ""
    
    var classes: DocumentReference? = nil
    
    @State var alertTitle = "Error"
    
    @State var alertMessage = "Cannot have empty friendly or enemy list. Please add another vehicle before removing this vehicle."
    
    var body: some View {
        VStack {
            if self.user.userType == "instructor" {
                Text("Create Assignment")
                .font(.largeTitle)
                .fontWeight(.black)
                TextField("Assignment Name", text: $name)
            } else {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.black)
            }
            Text("Directions: Click a vehicle to move it.  The order is Library -> Friendly -> Enemy -> Library")
            HStack {
                VStack {
                    Text("Library")
                        .font(.title)
                        .fontWeight(.heavy)
                    List {
                        ForEach(self.library, id: \.id) {card in
                            CardView(folder: card.name, back: Color.gray)
                                .onTapGesture {
                                    let index = self.library.firstIndex(of: card) ?? 0
                                    self.friendly.append(card)
                                    self.friendly = self.friendly.sorted()
                                    self.library.remove(at: index)
                            }
                        }
                    }
                }
                VStack {
                    Text("Friendly")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.friendly, id: \.id) {card in
                            CardView(folder: card.name, back: Color.blue)
                                .onTapGesture {
                                    let index = self.friendly.firstIndex(of: card) ?? 0
                                    self.enemy.append(card)
                                    self.enemy = self.enemy.sorted()
                                    self.friendly.remove(at: index)
                            }
                        }
                    }
                    Text("Enemy")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.enemy, id: \.id) {card in
                            CardView(folder: card.name, back: Color.red)
                                .onTapGesture {
                                    let index = self.enemy.firstIndex(of: card) ?? 0
                                    self.library.append(card)
                                    self.library = self.library.sorted()
                                    self.enemy.remove(at: index)
                            }
                        }
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
                }) {
                    Text("Reset")
                }
                Spacer()
                Button(action: {
                    self.save()
                }) {
                    Text("Save")
                }
                Spacer()
            }
        }
        .alert(isPresented: $alert) {
            Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("Dismiss"), action: {
                self.alert = false
            }))
        }.onAppear {
            self.library = Model.unselectedFolder.sorted()
            self.friendly = Model.friendlyFolder.sorted()
            self.enemy = Model.enemyFolder.sorted()
        }
    }
    
    func save() {
        if self.friendly.count == 0 || self.enemy.count == 0 {
            self.alertTitle = "Error"
            self.alertMessage = "Cannot have empty friendly or enemy list."
            self.alert = true
        } else {
            if self.user.userType == "instructor" {
                let coll = self.classes!.collection("assignments")
                coll.document(self.name).setData(["friendly":[], "enemy":[]])
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
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting().environmentObject(GlobalUser())
    }
}
