//
//  Tags.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 7/8/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import Foundation

/** Tag object to read tags from tags.json. */
struct Tags: Decodable {
    
    /** Image that is tagged. */
    let image: String
    
    /** List of tags. */
    let tags: [String]
}
