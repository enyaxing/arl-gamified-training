//
//  ButtonStyle.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 6/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import SwiftUI

struct FriendlyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
          .frame(width: 150, height: 55, alignment: .center)
          .font(Font.bodyFontBold)
          .foregroundColor(.white)
          .background(Color.armyGreen)
          .cornerRadius(10.0)
          .shadow(color: Color.armyGreen, radius: 0, x: 0, y: 4)
    }
}


struct EnemyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
          .frame(width: 150, height: 55, alignment: .center)
          .font(Font.bodyFontBold)
          .foregroundColor(.white)
          .background(Color.enemyRed)
          .cornerRadius(10.0)
          .shadow(color: Color.enemyRedShadow, radius: 0, x: 0, y: 4)
  }
}

struct CustomDefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
           .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          .font(Font.bodyFontBold)
          .foregroundColor(.white)
          .background(Color.armyGreen)
          .cornerRadius(10.0)
          .shadow(color: Color.armyGreen, radius: 0, x: 0, y: 4)
  }
}
