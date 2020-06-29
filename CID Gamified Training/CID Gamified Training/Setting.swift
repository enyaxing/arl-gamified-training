//
//  Setting.swift
//  CID Gamified Training
//
//  Created by Alex on 6/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct Setting: View {
    
    @State var library: [Card] = Model.unselectedFolder
    @State var friendly: [Card] = Model.friendlyFolder
    @State var enemy: [Card] = Model.enemyFolder
    @State var alert = false
    
    var body: some View {
        VStack {
            Text("Directions: Click a vehicle to move it.  The order is Library -> Friendly -> Enemy -> Library")
            HStack {
                VStack {
                    Text("Library")
                        .font(.title)
                        .fontWeight(.heavy)
                    List {
                        ForEach(self.library, id: \.id) {card in
                            CardView(folder: card.name, back: Color.gray)
                                .onTapGesture {
                                    let index = self.library.firstIndex(of: card) ?? 0
                                    self.friendly.append(card)
                                    self.library.remove(at: index)
                            }
                        }
                    }
                }
                VStack {
                    Text("Friendly")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.friendly, id: \.id) {card in
                            CardView(folder: card.name, back: Color.blue)
                                .onTapGesture {
                                    let index = self.friendly.firstIndex(of: card) ?? 0
                                    self.enemy.append(card)
                                    self.friendly.remove(at: index)
                            }
                        }
                    }
                    Text("Enemy")
                    .font(.title)
                    .fontWeight(.heavy)
                    List {
                        ForEach(self.enemy, id: \.id) {card in
                            CardView(folder: card.name, back: Color.red)
                                .onTapGesture {
                                    let index = self.enemy.firstIndex(of: card) ?? 0
                                    self.library.append(card)
                                    self.enemy.remove(at: index)
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text("Cannot have empty friendly or enemy list. Please add another vehicle before removing this vehicle."), dismissButton: .default(Text("Dismiss"), action: {
                self.alert = false
            }))
        }
        .onDisappear {
            Model.unselectedFolder = self.library
            Model.friendlyFolder = self.friendly
            Model.enemyFolder = self.enemy
            Model.friendly = Model.settingLoad(name: "friendly")
            Model.foe = Model.settingLoad(name: "enemy")
        } .onAppear {
            self.library = Model.unselectedFolder
            self.friendly = Model.friendlyFolder
            self.enemy = Model.enemyFolder
        }
    }
}

func location(geo: GeometryProxy, card: Card) -> String {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    let x = geo.frame(in: .global).midX + card.offset.width
    let y = geo.frame(in: .global).midY + card.offset.height
    var ret = ""
    
    if x < screenWidth * 0.5 {
        ret = "library"
    } else {
        if y < screenHeight * 0.5 {
            ret = "friendly"
        } else {
            ret = "enemy"
        }
    }
    return ret
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
    }
}
