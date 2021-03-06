//
//  Focus.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/16/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import SwiftUI
import Firebase

/** Change focus page. */
struct Focus: View {
    
    /** Which option is currently selected from picker. */
    @State var selection = "neutral"
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Reference to firebase users collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Save defaults locally (ie. who is signed in). */
    let defaults = UserDefaults.standard
    
    var body: some View {
        Color.lightBlack.edgesIgnoringSafeArea(.all).overlay(
            VStack {
                Text("Please select your focus style.")
                .foregroundColor(Color.white)
                Picker(selection: $selection, label: Text("Picker")) {
                    Text("Gain").tag("promotion").id(UUID())
                    Text("Loss").tag("prevention").id(UUID())
                    Text("Neutral").tag("neutral").id(UUID())
                } .pickerStyle(SegmentedPickerStyle())
            } .onDisappear {
                self.db.document(self.user.uid).setData(["focus": self.selection], merge: true)
                newFocus(db: self.db, user: self.user, defaults: self.defaults)
            }.onAppear {
                self.selection = self.user.regular
            }
        )
    }
}

struct Focus_Previews: PreviewProvider {
    static var previews: some View {
        Focus().environmentObject(GlobalUser())
    }
}
