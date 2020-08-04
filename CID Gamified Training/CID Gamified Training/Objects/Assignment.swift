//
//  Assignment.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 7/6/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import Foundation

/** Object representing a single assignment. */
struct Assignment {
    
    /** Name of assignment. */
    var name: String
    
    /** List of unselected vehicles. */
    var library: [Card]
    
    /** List of friendly vehicles. */
    var friendly: [Card]
    
    /** List of enemy vehicles. */
    var enemy: [Card]
    
    /** Required accuracy for friendly vehicles. */
    var friendlyAccuracy: Double
    
    /** Required accruacy for enemy vehicles. */
    var enemyAccuracy: Double
    
    /** Required time of completion. */
    var time: Double
}
