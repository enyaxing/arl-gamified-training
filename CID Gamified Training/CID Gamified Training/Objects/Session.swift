//
//  Session.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 6/29/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import Foundation
import Firebase

/** Object representing a session.
    Tracks session points, time of session, and type of session. */
struct Session {
    
    /** Points collected in a session */
    var points: Int
    
    /** Timestamp of the session. */
    var timestamp: Timestamp
    
    /** Type of session (Forced Choice or Go/No-Go)*/
    var type: String
    
}
