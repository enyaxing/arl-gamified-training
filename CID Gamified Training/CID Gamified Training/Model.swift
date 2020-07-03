//
//  Model.swift
//  CID Gamified Training
//
//  Created by Alex on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

/** Model represents photo to be displayed during training.
    Also has reference to list of friendly and foe vehicles for training. */
struct Model: Identifiable {
    
    /** Id variable for loops. */
    var id = UUID()
    
    /** File name in directory. */
    var imageURL: String
    
    /** Photo vehicle name. */
    var vehicleName: String
    
    /** List of friendly vehicles. */
    static var friendly = settingLoad(name: "friendly")
    
    /** List of foe vehicles. */
    static var foe = settingLoad(name: "enemy")
    
    /** List of friendly photo folders. */
    static var friendlyFolder: [Card] = [Card(name: "BRDM-2 Sagger")]
    
    /** List of enemy photo folders. */
    static var enemyFolder: [Card] = [Card(name: "BRDM-2 Spandrel")]
    
    /** List of unselected photo folders. */
    static var unselectedFolder: [Card] = dirLoad()
    
    /** Load the friendly and foe model arrays with friendlyFolder and enemyFolder card arrays. */
    static func settingLoad(name: String) -> [Model] {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/CID Images"
        
        var ret: [Model] = []
        if name == "friendly" {
            for card in self.friendlyFolder {
                do {
                    let items = try fm.contentsOfDirectory(atPath: path + "/" + card.name)
                    for item in items {
                        ret.append(Model(imageURL: path + "/" + card.name + "/\(item)", vehicleName: card.name))
                    }
                } catch {
                    print("error")
                }
            }
        } else if name == "enemy" {
            for card in self.enemyFolder {
                do {
                    let items = try fm.contentsOfDirectory(atPath: path + "/" + card.name)
                    for item in items {
                        ret.append(Model(imageURL: path + "/" + card.name + "/\(item)", vehicleName: card.name))
                    }
                } catch {
                    print("error")
                }
            }
        }
        return ret
    }
}

/** How to read file names in directory.
    Loads the unselected array. */
func dirLoad() -> [Card] {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath! + "/CID Images"
    var ret: [Card] = []
    do {
        let items = try fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item != "BRDM-2 Sagger" && item != "BRDM-2 Spandrel"{
                ret.append(Card(name: "\(item)"))
            }
        }
    } catch {
        print("error")
    }
    return ret
}
