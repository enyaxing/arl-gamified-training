//
//  StatBox.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 7/1/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct StatBox: View {
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    @State var img_name: String
    @State var description: String
    
    var body: some View {
        HStack {
            Image(self.img_name).resizable().frame(width: 24, height: 24)
            VStack(alignment: .leading) {
                
                Group {
                    if self.description == "sessions completed" {
                        Text("\(self.user.totalSessions)")
                        .font(Font.custom("Helvetica-Bold", size: 14.0))
                    } else if self.description == "time trained" {
                        Text("\(format_time_interval(second: self.user.totalTime))")
                        .font(Font.custom("Helvetica-Bold", size: 14.0))
                    } else if self.description == "avg response time" {
                        Text("\(String(format: "%.2f", self.user.avgResponseTime))s")
                        .font(Font.custom("Helvetica-Bold", size: 14.0))
                    } else if self.description == "accuracy" {
                        Text("\(String(format: "%.2f", self.user.accuracy))%")
                        .font(Font.custom("Helvetica-Bold", size: 14.0))
                    }
                }
                Text(self.description)
                    .font(Font.custom("Helvetica-Bold", size: 13.0))
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
        StatBox(img_name: "time", description: "minutes trained").environmentObject(GlobalUser())
    }
}
