//
//  Focus.swift
//  CID Gamified Training
//
//  Created by Alex on 6/16/20.
//  Copyright © 2020 Alex. All rights reserved.
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
    
    var body: some View {
        VStack {
            Text("Please select your focus style.")
            Picker(selection: $selection, label: Text("Picker")) {
                Text("promotion").tag("promotion").id(UUID())
                Text("prevention").tag("prevention").id(UUID())
                Text("neutral").tag("neutral").id(UUID())
            } .pickerStyle(SegmentedPickerStyle())
        } .onDisappear {
            self.db.document(self.user.uid).setData(["focus": self.selection], merge: true)
            self.user.regular = self.selection
        }.onAppear {
            self.selection = self.user.regular
        }
    }
}

struct Focus_Previews: PreviewProvider {
    static var previews: some View {
        Focus().environmentObject(GlobalUser())
    }
}
