//
//  SummaryDetail.swift
//  CID Gamified Training
//
//  Created by Alex on 6/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct SummaryDetail: View {
    var body: some View {
        VStack {
                ScrollView {
             Text("Summary")
                 .font(.largeTitle)
                 .fontWeight(.bold)
                    VStack {
                        Image("tank2").resizable().scaledToFit()
             HStack {
                 Text("The correct answer is")
                     .font(.title)
                     .fontWeight(.semibold)
                 Text("Friend")
                     .font(.title)
                     .fontWeight(.semibold)
                     .foregroundColor(Color.green)
                 + Text(".")
                     .font(.title)
                     .fontWeight(.semibold)
                    }
             HStack {
                 Text("You chose")
                     .font(.title)
                     .fontWeight(.semibold)
                 Text("Foe")
                     .font(.title)
                     .fontWeight(.semibold)
                     .foregroundColor(Color.red)
                 + Text(".")
                     .font(.title)
                     .fontWeight(.semibold)
                    }
            
                }
            }
        }
    }
}

struct SummaryDetail_Previews: PreviewProvider {
    static var previews: some View {
        SummaryDetail()
    }
}
