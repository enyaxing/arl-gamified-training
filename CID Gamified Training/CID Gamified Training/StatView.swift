//
//  SwiftUIView.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 7/14/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import SwiftUI

/** Individual rows in the stat detail page. */
struct StatView: View {
    
    /** Name of vehicle or tag. */
    var name: String
    
    /** Number to be displayed.
     Can be accuracy percentage or time in seconds. */
    var num: Double
    
    /** 0==accuracy, 1==time*/
    var type: Int
    
    var body: some View {
        HStack {
            Text(name)
            if type == 0 {
                Text("\(num * 100, specifier: "%.1f")%")
            } else {
                Text("\(num, specifier: "%.1f") s")
            }
        }
    }
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        StatView(name: "AAV", num: 1, type: 0)
    }
}
