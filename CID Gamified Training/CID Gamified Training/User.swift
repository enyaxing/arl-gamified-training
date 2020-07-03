//
//  User.swift
//  CID Gamified Training
//
//  Created by Alex on 6/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

/** Global user class to store user uid and regular focus type. */
class GlobalUser: ObservableObject {
    @Published var uid = UserDefaults.standard.string(forKey: "uid") ?? ""
    @Published var regular = UserDefaults.standard.string(forKey: "focus") ?? "None"
    @Published var userType = UserDefaults.standard.string(forKey: "userType") ?? "student"
    
    /** Total time played. */
    @Published var totalTime: TimeInterval = 0.00
}
