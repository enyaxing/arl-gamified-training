//
//  AssignmentDetail.swift
//  CID Gamified Training
//
//  Created by Alex on 7/6/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct AssignmentDetail: View {
    
    var assignment: Assignment
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AssignmentDetail_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetail(assignment: Assignment(name: "", library: [], friendly: [], enemy: []))
    }
}
