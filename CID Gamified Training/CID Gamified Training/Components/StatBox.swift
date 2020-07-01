//
//  StatBox.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 7/1/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct StatBox: View {
    @State var img_name: String
    @State var title: String
    @State var description: String
    
    var body: some View {
        HStack {
            Image(self.img_name).resizable().frame(width: 24, height: 24)
            VStack(alignment: .leading) {
                Text(self.title)
                    .font(Font.custom("Helvetica-Bold", size: 14.0))
                Text(self.description)
                    .font(Font.custom("Helvetica", size: 13.0))
            }
        }
        .frame(width: UIScreen.screenWidth * 0.4, height: UIScreen.screenHeight / 20, alignment: .leading)
        .padding(UIScreen.screenWidth * 0.025)
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(Color.outlineGray, lineWidth: 2)
        )
    }
}

struct StatBox_Previews: PreviewProvider {
    static var previews: some View {
        StatBox(img_name: "time", title: "97", description: "minutes trained")
    }
}
