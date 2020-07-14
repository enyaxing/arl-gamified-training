//
//  SwiftUIView.swift
//  CID Gamified Training
//
//  Created by Alex on 7/14/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct StatView: View {
    
    var name: String
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
