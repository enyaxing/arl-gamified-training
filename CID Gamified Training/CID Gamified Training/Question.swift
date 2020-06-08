//
//  Question.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Question: View {
    var body: some View {
        Picker(selection:  /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
            /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
            /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
        }
    }
}

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        Question()
    }
}
