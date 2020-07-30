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
    static var armyGreen: Color {
       return Color(red: 0.302, green: 0.471, blue: 0.306, opacity: 1)
    }
    
    static var lightBlack: Color {
        return Color(UIColor(red: 0.142, green: 0.142, blue: 0.142, alpha: 1))
    }
    
    static var darkBlue: Color {
        return Color(UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 0.8))
    }

    static var armyGreenShadow: Color {
        return Color(red: 0.250, green: 0.42, blue: 0.28, opacity: 1)
    }
    
    static var enemyRed: Color {
        return Color(UIColor(red: 0.708, green: 0.163, blue: 0.133, alpha: 1))
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


/** Start of view modifiers. */
/** Input is a modifier for text input fields. */
struct Input: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 30.0)
            .padding(.vertical)
            .font(.custom("Helvetica", size: 16))
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(#colorLiteral(red: 0.10196078568696976, green: 0.10196078568696976, blue: 0.10980392247438431, alpha: 1)))
                    .frame(width: 343, height: 50)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
            )
    }
}

/** Rounded button is a view modifier for round buttons to be applied to the text of the button. */
/** Currently being used in the sign in and sign up pages. */
struct CustomRoundedButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Helvetica-Bold", size: 16)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .multilineTextAlignment(.center)
            .background(//Rectangle 9
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.armyGreen)
                    .frame(width: 229, height: 46)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
            )
    }
}


/** Wrapping modifiers*/
extension View {
    func inputStyle() -> some View {
        self.modifier(Input())
    }
    func customRoundedButtonTextStyle() -> some View {
        self.modifier(CustomRoundedButtonStyle())
    }
}
