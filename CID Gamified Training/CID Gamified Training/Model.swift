//
//  Model.swift
//  CID Gamified Training
//
//  Created by Alex on 6/15/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

struct Model: Identifiable {
    var id = UUID()
    var imageURL: String
    
    static let friendly = load(name: "friendly")
    
    static let foe = load(name: "foe")
}

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
