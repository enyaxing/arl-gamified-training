//
//  StopWatchManager.swift
//  StopWatchDemoEN
//
//  Created by Farukh IQBAL on 13/06/2020.
//  Copyright © 2020 Farukh Academy. All rights reserved.
//

import Foundation
import SwiftUI

class StopWatchManager: ObservableObject {
    
//    enum stopWatchMode {
//        case running
//        case stopped
//    }
    
//    @Published var mode: stopWatchMode = .running
    
    @Published var secondsElapsed = 0.0
    var timer = Timer()
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.secondsElapsed += 0.1
        }
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
    }
}

