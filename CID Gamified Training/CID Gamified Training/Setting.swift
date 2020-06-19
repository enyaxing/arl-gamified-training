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
    
    var body: some View {
        HStack {
            VStack {
                Text("Library")
                List {
                    ForEach(self.library, id: \.id) {card in
                        GeometryReader { geo in
                            Text(card.name)
                            .offset(card.offset)
                            .gesture(DragGesture()
                            .onChanged { gesture in
                                let index = self.library.firstIndex(of: card) ?? 0
                                self.library[index].offset = gesture.translation
                            }.onEnded { _ in
                                if location(geo: geo, card: card) == "friendly" {
                                    self.friendly.append(card)
                                    self.friendly[self.friendly.count - 1].offset = CGSize.zero
                                } else if location(geo: geo, card: card) == "enemy" {
                                    self.enemy.append(card)
                                    self.enemy[self.enemy.count - 1].offset = CGSize.zero
                                }
                                let index = self.library.firstIndex(of: card) ?? 0
                                self.library.remove(at: index)
                            })
                        }
                    }
                }
            }
            VStack {
                Text("Friendly")
                List {
                    ForEach(self.friendly, id: \.id) {card in
                        GeometryReader { geo in
                            Text(card.name)
                            .offset(card.offset)
                            .gesture(DragGesture()
                            .onChanged { gesture in
                                let index = self.friendly.firstIndex(of: card) ?? 0
                                self.friendly[index].offset = gesture.translation
                            }.onEnded { _ in
                                if location(geo: geo, card: card) == "library" {
                                    self.library.append(card)
                                    self.library[self.library.count - 1].offset = CGSize.zero
                                } else if location(geo: geo, card: card) == "enemy" {
                                    self.enemy.append(card)
                                    self.enemy[self.enemy.count - 1].offset = CGSize.zero
                                }
                                let index = self.friendly.firstIndex(of: card) ?? 0
                                self.friendly.remove(at: index)
                            })
                        }
                    }
                }
                Text("Enemy")
                List {
                    ForEach(self.enemy, id: \.id) {card in
                        GeometryReader { geo in
                            Text(card.name)
                            .offset(card.offset)
                            .gesture(DragGesture()
                            .onChanged { gesture in
                                let index = self.enemy.firstIndex(of: card) ?? 0
                                self.enemy[index].offset = gesture.translation
                            }.onEnded { _ in
                                if location(geo: geo, card: card) == "friendly" {
                                    self.friendly.append(card)
                                    self.friendly[self.friendly.count - 1].offset = CGSize.zero
                                } else if location(geo: geo, card: card) == "library" {
                                    self.library.append(card)
                                    self.library[self.library.count - 1].offset = CGSize.zero
                                }
                                let index = self.enemy.firstIndex(of: card) ?? 0
                                self.enemy.remove(at: index)
                            })
                        }
                    }
                }
            }
        }.onDisappear {
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
