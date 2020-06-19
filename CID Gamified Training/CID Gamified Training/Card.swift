//
//  Card.swift
//  CID Gamified Training
//
//  Created by Alex on 6/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import SwiftUI

struct Card : Identifiable, Equatable {
    var id = UUID()
    var name: String
    var offset = CGSize.zero
}
