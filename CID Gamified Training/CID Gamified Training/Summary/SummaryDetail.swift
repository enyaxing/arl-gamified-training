//
//  SummaryDetail.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/12/20.
//  Copyright © 2020 X-Force. All rights reserved.
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
            if !ARMode {
                Color.lightBlack.edgesIgnoringSafeArea(.all).overlay(
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
                            .foregroundColor(Color.white)
                        + Text(self.answer.expected)
                         .font(.title)
                         .fontWeight(.semibold)
                         .foregroundColor(Color.darkBlue)
                        + Text(",")
                        .font(.title)
                        .fontWeight(.semibold)
                            .foregroundColor(.white)
                         Text("the correct answer.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        }
                      }
                    } else {
                     HStack {
                     Text("The correct answer is")
                         .font(.title)
                         .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    Text(self.answer.expected)
                         .font(.title)
                         .fontWeight(.semibold)
                         .foregroundColor(Color.darkBlue)
                     + Text(".")
                         .font(.title)
                         .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        }
                 HStack {
                     Text("You chose")
                         .font(.title)
                         .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    Text(self.answer.received)
                         .font(.title)
                         .fontWeight(.semibold)
                         .foregroundColor(Color.enemyRed)
                     + Text(".")
                         .font(.title)
                         .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    }
                    }
                })
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
