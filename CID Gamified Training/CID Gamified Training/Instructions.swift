//
//  Instructions.swift
//  CID Gamified Training
//
//  Created by Alex on 6/23/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Instructions: View {
    
    let friendly: [Card] = Model.friendlyFolder
    let enemy: [Card] = Model.enemyFolder
    
    /**1 == training, 2==gonogo*/
    var type: Int
    
    /** Show instructions. */
    @Binding var instructions: Bool
    
    /** To close the view. */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
       
   var btnBack : some View {
       Button(action: {
       self.presentationMode.wrappedValue.dismiss()
       }) {
           HStack {
           Image("close")
               .aspectRatio(contentMode: .fit)
               .foregroundColor(.black)
           }
       }
   }
    
    var body: some View {
        
        VStack {
            HStack {
                btnBack
                Spacer()
            }
            Group {
                if type == 1 {
                    Text("You are about to enter the Training game mode.  You must classify 20 vehicles as either friendly or enemy by clicking the corresponding buttons.  The list of friendly and enemy vehicles are shown below.  Good luck!")
                        .font(.title)
                        .fontWeight(.medium)
                } else {
                    Text("You are about to enter the Gonogo game mode.  You must classify 20 vehicles as either friendly.  The default answer is friendly.  To select friendly, simply wait for the turn timer to expire.  To select enemy, click the enemy button at the bottom of the screen.  The list of friendly and enemy vehicles are shown below.  Good luck!")
                }
            }
            Spacer()
            HStack{
                VStack {
                    Text("Friendly")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.enemy, id: \.id) {card in
                            CardView(folder: card.name)
                        }
                    }
                }
                VStack {
                    Text("Enemy")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.friendly, id: \.id) {card in
                            CardView(folder: card.name)
                        }
                    }
                }
            }
            Spacer()
            Button(action: {self.instructions = false}) {
                Text("Start")
                    .font(.largeTitle)
                    .fontWeight(.black)
            }
            Spacer()
        }
    }
}

struct Instructions_Previews: PreviewProvider {
    static var previews: some View {
        Instructions(type: 1, instructions: Binding.constant(true))
    }
}
