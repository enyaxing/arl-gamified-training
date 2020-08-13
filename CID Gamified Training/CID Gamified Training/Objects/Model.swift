//
//  Model.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/15/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import Foundation
import Combine
import Firebase

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
    
    /** Load the friendly and foe model arrays with friendlyFolder and enemyFolder card arrays.
     Parameters:
        name - String, either "friendly" or "enemy" indicating which should be loaded.
     Return:
        An array of Models to be used in the training games.*/
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

/** Syncs the enemy and friendly settings with the ones present in firebase.
 Parameters:
    uid - String representing the user's uid*/
func initial(uid: String) {
    let db = Firestore.firestore().collection("users").document(uid)
    var friend: [Card] = []
    var foe: [Card] = []
    let fm = FileManager.default
    let path = Bundle.main.resourcePath! + "/CID Images"
    var ret: [Card] = []
    db.getDocument { (docu, error) in
        if let docu = docu, docu.exists {
            if docu.get("friendly") != nil {
                let vehicles = docu.get("friendly") as! [String]
                for vehicle in vehicles {
                    friend.append(Card(name: vehicle))
                }
                Model.friendlyFolder = friend.sorted()
            }
            if docu.get("enemy") != nil {
                let vehicles = docu.get("enemy") as! [String]
                for vehicle in vehicles {
                    foe.append(Card(name: vehicle))
                }
                Model.enemyFolder = foe.sorted()
            }
        } else {
            print("Document does not exist")
        }
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            for item in items {
                if check(name: item, arr: Model.friendlyFolder) && check(name: item, arr: Model.enemyFolder) {
                    ret.append(Card(name: "\(item)"))
                }
            }
            Model.unselectedFolder = ret.sorted()
        } catch {
            print("error")
        }
    }
}

/** Checks if a certain vehicle is present in a folder.
 Parameters:
    name - String of the vehicle to search for.
    arr - Array of Cards representing a folder either enemy or friendly
 Return:
    Bool indicating whether the vehicle is present or not.*/
func check(name: String, arr: [Card]) -> Bool {
    for card in arr {
        if name == card.name {
            return false
        }
    }
    return true
}

/** How to read file names in directory.
    Loads the unselected array.
 Return:
    An array of Cards representign the unselected vehicles.*/
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
