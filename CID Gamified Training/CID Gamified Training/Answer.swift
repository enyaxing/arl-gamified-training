//
//  Answer.swift
//  CID Gamified Training
//
//  Created by Alex on 6/12/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

/** Class representing an answer to a question.
    Primarily used to store answers during session and display during summary.*/
struct Answer {
    
    /** Question number. */
    var id: Int
    
    /** Expected response. */
    var expected: String
    
    /** Received response. */
    var received: String
    
    /**Image to display. */
    var image: String
    
    /** Vehicle name. */
    var vehicleName: String
    
    var time: Double = 0.0
}
