//
//  Style.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 6/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    // colors
    static var friendlyGreen: Color {
        return Color(red: 0.302, green: 0.713, blue: 0.476, opacity: 1)
    }
    
    static var friendlyGreenShadow: Color {
        return Color(red: 0.08, green: 0.62, blue: 0.31, opacity: 1.0)
    }
    
    static var enemyRed: Color {
        return Color(red: 1, green: 0.231, blue: 0.188, opacity: 1)
    }
    
    static var enemyRedShadow: Color {
        return Color(red: 0.708, green: 0.163, blue: 0.133, opacity: 1)
    }
    
    static var progressBarBackground: Color {
        return Color(red: 0.75, green: 0.75, blue: 0.75, opacity: 1)
    }
    
    static var outlineGray: Color {
        return Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1))
    }
}

extension Font {
    static var bodyFontBold: Font {
        return Font.custom("Helvetica-Bold", size: 18.0)
    }
    
    static var headingFont: Font {
        return Font.custom("Helvetica-Bold", size: 24.0)
    }
    
    static var bodyFont: Font {
        return Font.custom("Helvetica", size: 18.0)
    }
    
    static var bodyFontSmall: Font {
        return Font.custom("Helvetica", size: 13.0)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
