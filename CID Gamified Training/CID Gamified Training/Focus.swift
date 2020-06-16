//
//  Focus.swift
//  CID Gamified Training
//
//  Created by Alex on 6/16/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Focus: View {
    
    let defaults = UserDefaults.standard
    
    /** Used to pass regulatory focus type to other views. */
    @Binding var regular: String
    
    @State var selection = focus(defaults: UserDefaults.standard)
    
    var body: some View {
        VStack {
            Text("Please select your focus style.")
            Picker(selection: $selection, label: Text("Picker")) {
                Text("promotion").tag("promotion")
                Text("prevention").tag("prevention")
                Text("equal").tag("equal")
            } .pickerStyle(SegmentedPickerStyle())
        } .onDisappear {
            self.defaults.set(self.selection, forKey: "focus")
            self.regular = focus(defaults: self.defaults)
        }
    }
}

struct Focus_Previews: PreviewProvider {
    static var previews: some View {
        Focus(regular: ContentView().$regular)
    }
}
