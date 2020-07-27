//
//  SummaryDetail.swift
//  CID Gamified Training
//
//  Created by Alex on 6/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

/** Detailed description of a single answer. */
struct SummaryDetail: View {
    
    /** A single answer to be displayed. */
    var answer: Answer
    
    /** Hide navigation back button. */
    @Binding var back: Bool
    
    @State var ARMode = false
    
    @State var file = false
    
    var body: some View {
        
        Group {
            if !self.ARMode {
                VStack {
                   Image(uiImage: UIImage(imageLiteralResourceName: self.answer.image))
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   if self.answer.expected == self.answer.received {
                       HStack {
                           VStack {
                        Text("You chose ")
                        .font(.title)
                        .fontWeight(.semibold)
                       + Text(self.answer.expected)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.blue)
                       + Text(",")
                       .font(.title)
                       .fontWeight(.semibold)
                        Text("the correct answer.")
                       .font(.title)
                       .fontWeight(.semibold)
                       }
                     }
                   } else {
                    HStack {
                    Text("The correct answer is")
                        .font(.title)
                        .fontWeight(.semibold)
                   Text(self.answer.expected)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.blue)
                    + Text(".")
                        .font(.title)
                        .fontWeight(.semibold)
                       }
                HStack {
                    Text("You chose")
                        .font(.title)
                        .fontWeight(.semibold)
                   Text(self.answer.received)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                    + Text(".")
                        .font(.title)
                        .fontWeight(.semibold)
                       }
                   }
                   Text("You answered in \(self.answer.time, specifier: "%.1f") seconds.")
                   Text("(This is a \(self.answer.vehicleName))")
                   Spacer()
                }
            } else {
                ARScreen(vehicleName: self.answer.vehicleName)
            }
            if self.file {
                Toggle("3D View", isOn: $ARMode)
            }
        }.onAppear {
            self.back = true
            self.file = checkFileExists(vehicleName: self.answer.vehicleName)
        }.onDisappear {
            self.back = false
        }
    }
}

func checkFileExists(vehicleName: String) -> Bool {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath! + "/3D Models"
    return fm.fileExists(atPath: "\(path)/\(vehicleName).usdz")
}

struct SummaryDetail_Previews: PreviewProvider {
    static var previews: some View {
        SummaryDetail(answer: Answer(id: 1, expected: "foe", received: "foe", image: "tank1", vehicleName: "tank1"), back: Binding.constant(true))
    }
}
