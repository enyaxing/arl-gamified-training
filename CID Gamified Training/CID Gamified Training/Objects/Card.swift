//
//  Card.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/19/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import Foundation
import SwiftUI

/** Card object that tracks vehicle name and lets cards be comparable. */
struct Card : Identifiable, Equatable, Comparable {
    
    /** Id of the Card. */
    var id = UUID()
    
    /** Name of vehicle on card. */
    var name: String
    
    /** Card comparator function. */
    static func < (lhs: Card, rhs: Card) -> Bool {
        return lhs.name < rhs.name
    }
}
