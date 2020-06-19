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
    
    /** List of friendly vehicles. */
    static var friendly = dirLoad(name: "Friendly")
    
    /** List of foe vehicles. */
    static var foe = dirLoad(name: "Foe")
    
    static var friendlyFolder: [Card] = []
    static var enemyFolder: [Card] = []
    static var unselectedFolder: [Card] = []
}

/** How to read a text file. */
func load(name: String) -> [Model] {
    if let filepath = Bundle.main.path(forResource: name, ofType: "txt") {
        do {
            let contents = try String(contentsOfFile: filepath)
            print(contents)
            let list = contents.components(separatedBy: "\n")
            var url: [Model] = []
            for (link) in list {
                if !link.isEmpty {
                    url.append(.init(imageURL: link))
                }
            }
            return url
        } catch {
            // contents could not be loaded
            return []
        }
    } else {
        // example.txt not found!
        return []
    }
}

/** How to read file names in directory. */
func dirLoad(name: String) -> [Model] {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath! + "/" + name
    print(path)
    var ret: [Model] = []
    do {
        let items = try fm.contentsOfDirectory(atPath: path)
        for item in items {
            print("Found \(item)")
            ret.append(Model(imageURL: path + "/\(item)"))
        }
    } catch {
        print("error")
    }
    return ret
}
