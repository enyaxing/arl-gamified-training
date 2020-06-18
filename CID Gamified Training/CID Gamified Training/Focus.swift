//
//  Focus.swift
//  CID Gamified Training
//
//  Created by Alex on 6/16/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct Focus: View {
    
    /** Used to pass regulatory focus type to other views. */
    @Binding var regular: String
    
    @State var selection = "neutral"
    
    @Binding var uid: String
    
    let db = Firestore.firestore().collection("users")
    
    var body: some View {
        VStack {
            Text("Please select your focus style.")
            Picker(selection: $selection, label: Text("Picker")) {
                Text("promotion").tag("promotion")
                Text("prevention").tag("prevention")
                Text("neutral").tag("neutral")
            } .pickerStyle(SegmentedPickerStyle())
        } .onDisappear {
            self.db.document(self.uid).setData(["focus": self.selection], merge: true)
            self.regular = self.selection
        } .onAppear {
            self.selection = self.regular
        }
    }
}

struct Focus_Previews: PreviewProvider {
    static var previews: some View {
        Focus(regular: Binding.constant("neutral"), uid: Binding.constant(""))
    }
}
