//
//  Summary.swift
//  CID Gamified Training
//
//  Created by Alex on 6/11/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Summary: View {
    
    @Binding var showing: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary(showing: Training().$summary)
    }
}
